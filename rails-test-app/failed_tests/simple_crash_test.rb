#!/usr/bin/env ruby

puts "🚨 SIMPLE CRASH TEST FOR CLEAN RAILS APP"
puts "========================================="
puts "Testing ActionController::Live crash reproduction"
puts ""

# Load basic Rails components
begin
  require "bundler/setup"
  require "action_controller"
  require "action_controller/metal/live"
  require "pg"
  puts "✅ Basic components loaded successfully"
rescue => e
  puts "❌ Error loading components: #{e.class}: #{e.message}"
  exit 1
end

puts ""
puts "🧪 Testing ActionController::Live with PostgreSQL..."
puts ""

# Create a simple test controller
class SimpleTestController < ActionController::Base
  include ActionController::Live
  
  def initialize
    super
    @connections = []
  end
  
  def test_stream
    puts "🔄 Starting streaming test in thread #{Thread.current.object_id}"
    
    begin
      # Create PostgreSQL connections to trigger the race condition
      create_test_connections
      
      # Simulate streaming response
      puts "📤 Simulating streaming response..."
      
      # Add delay to increase race condition probability
      sleep(rand(0.01..0.05))
      
      puts "✅ Streaming test completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ Error in streaming test: #{e.class}: #{e.message}"
    end
  end
  
  private
  
  def create_test_connections
    puts "🔌 Creating PostgreSQL connections..."
    
    # Create multiple PostgreSQL connections to trigger the crash
    connections = []
    
    3.times do |i|
      begin
        conn = PG.connect(
          host: 'postgres',
          port: 5432,
          dbname: 'postgres',
          user: 'postgres',
          password: 'postgres'
        )
        
        connections << conn
        
        # Execute a query to keep connection active
        result = conn.exec("SELECT #{i} as connection_num, pg_backend_pid() as pid")
        puts "   ✅ Connection #{i + 1} created (PID: #{result[0]['pid']})"
        
      rescue => e
        puts "   ❌ Error creating connection #{i}: #{e.class}: #{e.message}"
      end
    end
    
    @connections.concat(connections)
    
    # Simulate the race condition: multiple threads accessing the same connection
    if connections.any?
      puts "⚠️  Simulating race conditions..."
      
      connections.each do |conn|
        Thread.new do
          begin
            # Wait for the exact moment to create the race condition
            sleep(rand(0.001..0.005))
            
            # This is where the crash should happen: concurrent access
            result = conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
            puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"
            
            # Simulate the "double concurrent PG#close" scenario
            if rand < 0.3
              puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"
              
              2.times do |j|
                Thread.new do
                  begin
                    sleep(rand(0.0001..0.001))
                    conn.close  # This should trigger the crash
                    puts "      🧹 Thread #{Thread.current.object_id} closed connection (#{j + 1})"
                  rescue => e
                    puts "      ❌ Error closing connection: #{e.class}: #{e.message}"
                  end
                end
              end
            end
            
          rescue => e
            puts "   ❌ Error in race condition thread: #{e.class}: #{e.message}"
          end
        end
      end
    end
  end
end

# Test the controller
puts "🧪 Creating test controller..."
controller = SimpleTestController.new
puts "✅ Test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts ""

# This is where the crash might happen
controller.test_stream

puts ""
puts "🔍 Checking for core dumps..."
if Dir.exist?("/tmp/core_dumps")
  core_files = Dir.glob("/tmp/core_dumps/*")
  if core_files.any?
    puts "🎯 CORE DUMP DETECTED!"
    core_files.each { |f| puts "  📁 #{f}" }
  else
    puts "ℹ️  No core dumps found"
  end
else
  puts "ℹ️  Core dump directory not found"
end

puts ""
puts "🏁 Simple crash test completed"
puts "Check the output above for any errors or core dumps"
