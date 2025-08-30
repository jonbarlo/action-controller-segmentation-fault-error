#!/usr/bin/env ruby

puts "💥 ENHANCED CRASH TEST - Maximum Pressure!"
puts "============================================"
puts "Testing ActionController::Live crash reproduction with MAXIMUM pressure"
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
puts "🧪 Testing ActionController::Live with MAXIMUM PostgreSQL pressure..."
puts ""

# Create an enhanced test controller with maximum pressure
class EnhancedTestController < ActionController::Base
  include ActionController::Live
  
  def initialize
    super
    @connections = []
    @race_conditions_triggered = 0
    @double_close_attempts = 0
    @total_connections = 0
  end
  
  def test_stream
    puts "🔄 Starting ENHANCED streaming test in thread #{Thread.current.object_id}"
    
    begin
      # Create MANY more PostgreSQL connections to trigger the crash
      create_maximum_connections
      
      # Simulate streaming response with more pressure
      puts "📤 Simulating streaming response with maximum pressure..."
      
      # Add aggressive delay to increase race condition probability
      sleep(rand(0.005..0.015))
      
      puts "✅ ENHANCED streaming test completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ Error in enhanced streaming test: #{e.class}: #{e.message}"
    end
  end
  
  private
  
  def create_maximum_connections
    puts "🔌 Creating MAXIMUM PostgreSQL connections..."
    
    # Create MANY more connections (10 instead of 3)
    connections = []
    
    10.times do |i|
      begin
        conn = PG.connect(
          host: 'postgres',
          port: 5432,
          dbname: 'postgres',
          user: 'postgres',
          password: 'postgres'
        )
        
        connections << conn
        @total_connections += 1
        
        # Execute a query to keep connection active
        result = conn.exec("SELECT #{i} as connection_num, pg_backend_pid() as pid")
        puts "   ✅ Connection #{i + 1} created (PID: #{result[0]['pid']})"
        
      rescue => e
        puts "   ❌ Error creating connection #{i}: #{e.class}: #{e.message}"
      end
    end
    
    @connections.concat(connections)
    
    # Simulate MAXIMUM race conditions: multiple threads accessing the same connection
    if connections.any?
      puts "⚠️  Simulating MAXIMUM race conditions..."
      
      connections.each do |conn|
        # Create MORE threads per connection (5 instead of 1)
        5.times do |thread_num|
          Thread.new do
            begin
              # Wait for the exact moment to create the race condition
              sleep(rand(0.0001..0.002))  # More aggressive timing
              
              # This is where the crash should happen: concurrent access
              result = conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
              puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"
              
              # Simulate the "double concurrent PG#close" scenario with MAXIMUM aggression
              if rand < 0.5  # 50% chance of double close (increased from 30%)
                @double_close_attempts += 1
                puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"
                
                # Create MORE threads trying to close the same connection (5 instead of 2)
                5.times do |j|
                  Thread.new do
                    begin
                      sleep(rand(0.0001..0.0003))  # Ultra-aggressive timing
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
      
      @race_conditions_triggered += 1
    end
  end
  
  def get_stats
    {
      total_connections: @total_connections,
      race_conditions_triggered: @race_conditions_triggered,
      double_close_attempts: @double_close_attempts
    }
  end
end

# Test the enhanced controller
puts "🧪 Creating enhanced test controller..."
controller = EnhancedTestController.new
puts "✅ Enhanced test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts ""

# This is where the crash might happen with MAXIMUM pressure
controller.test_stream

# Wait a bit for all threads to complete
sleep(2)

puts ""
puts "📊 ENHANCED TEST STATISTICS:"
stats = controller.get_stats
puts "   Total connections created: #{stats[:total_connections]}"
puts "   Race conditions triggered: #{stats[:race_conditions_triggered]}"
puts "   Double close attempts: #{stats[:double_close_attempts]}"
puts ""

puts "🔍 Checking for core dumps..."
if Dir.exist?("/tmp/core_dumps")
  core_files = Dir.glob("/tmp/core_dumps/*")
  if core_files.any?
    puts "🎯 CORE DUMP DETECTED!"
    core_files.each { |f| puts "  📁 #{f}" }
    puts ""
    puts "💡 The segmentation fault occurred! Analyze with:"
    puts "   gdb /usr/local/bin/ruby /tmp/core_dumps/core.ruby.*"
  else
    puts "ℹ️  No core dumps found - crash may not have occurred"
  end
else
  puts "ℹ️  Core dump directory not found"
end

puts ""
puts "🏁 Enhanced crash test completed"
puts "This test used MAXIMUM pressure to trigger the crash!"
puts "Check the output above for any errors or core dumps"
