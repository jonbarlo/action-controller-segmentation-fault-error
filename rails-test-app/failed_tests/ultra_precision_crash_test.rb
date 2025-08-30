#!/usr/bin/env ruby

puts "💥 ULTRA PRECISION CRASH TEST - Maximum Pressure + Multiple Iterations!"
puts "======================================================================"
puts "Testing ActionController::Live crash reproduction with ULTRA precision + iterations"
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
puts "🧪 Testing ActionController::Live with ULTRA precision + multiple iterations..."
puts ""

# Create an ultra-aggressive precision test controller
class UltraPrecisionTestController < ActionController::Base
  include ActionController::Live
  
  def initialize
    super
    @connections = []
    @race_conditions_triggered = 0
    @double_close_attempts = 0
    @total_connections = 0
    @iterations = 0
  end
  
  def test_stream
    puts "🔄 Starting ULTRA PRECISION streaming test in thread #{Thread.current.object_id}"
    
    begin
      # Run multiple iterations to increase crash probability
      3.times do |iteration|
        @iterations += 1
        puts "🔄 ITERATION #{@iterations} - Maximum Pressure!"
        
        # Create connections with ULTRA precision
        create_ultra_precision_connections
        
        # Simulate streaming response with maximum pressure
        puts "📤 Simulating streaming response with ULTRA precision..."
        
        # Add ultra-precise delay to increase race condition probability
        sleep(rand(0.0001..0.001))
        
        puts "✅ ITERATION #{@iterations} completed"
        
        # Small delay between iterations
        sleep(0.1)
      end
      
      puts "✅ ULTRA PRECISION streaming test completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ Error in ultra precision streaming test: #{e.class}: #{e.message}"
    end
  end
  
  def create_ultra_precision_connections
    puts "🔌 Creating ULTRA PRECISION PostgreSQL connections..."
    
    # Create connections with ULTRA precision
    connections = []
    
    5.times do |i|
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
    
    # Simulate ULTRA PRECISE race conditions: focus on the exact timing
    if connections.any?
      puts "⚠️  Simulating ULTRA PRECISE race conditions..."
      
      connections.each do |conn|
        # Create ULTRA PRECISE threads with exact timing
        4.times do |thread_num|
          Thread.new do
            begin
              # ULTRA PRECISE timing: wait for the exact moment
              sleep(rand(0.00001..0.0001))  # Microsecond precision
              
              # This is where the crash should happen: concurrent access
              result = conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
              puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"
              
              # Simulate the "double concurrent PG#close" scenario with ULTRA PRECISE timing
              if rand < 0.8  # 80% chance of double close (increased probability)
                @double_close_attempts += 1
                puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"
                
                # Create ULTRA PRECISE threads trying to close the same connection
                4.times do |j|
                  Thread.new do
                    begin
                      # ULTRA PRECISE timing: this is the key to the crash
                      sleep(rand(0.000001..0.00001))  # Nanosecond precision
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
  
  def stats
    {
      total_connections: @total_connections,
      race_conditions_triggered: @race_conditions_triggered,
      double_close_attempts: @double_close_attempts,
      iterations: @iterations
    }
  end
end

# Test the ultra precision controller
puts "🧪 Creating ultra precision test controller..."
controller = UltraPrecisionTestController.new
puts "✅ Ultra precision test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts ""

# This is where the crash might happen with ULTRA PRECISION + multiple iterations
controller.test_stream

# Wait a bit for all threads to complete
sleep(5)

puts ""
puts "📊 ULTRA PRECISION TEST STATISTICS:"
stats = controller.stats
puts "   Total connections created: #{stats[:total_connections]}"
puts "   Race conditions triggered: #{stats[:race_conditions_triggered]}"
puts "   Double close attempts: #{stats[:double_close_attempts]}"
puts "   Iterations completed: #{stats[:iterations]}"
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
puts "🏁 Ultra precision crash test completed"
puts "This test used ULTRA PRECISE timing + multiple iterations to trigger the crash!"
puts "Check the output above for any errors or core dumps"
