#!/usr/bin/env ruby
# frozen_string_literal: true

puts "💾 MEMORY PRESSURE CRASH TEST - Race Conditions + Memory Exhaustion!"
puts "===================================================================="
puts "Testing ActionController::Live crash reproduction with memory pressure"
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
puts "🧪 Testing ActionController::Live with memory pressure + race conditions..."
puts ""

# Create a memory pressure test controller
class MemoryPressureTestController < ActionController::Base
  include ActionController::Live

  def initialize
    super
    @connections = []
    @race_conditions_triggered = 0
    @double_close_attempts = 0
    @total_connections = 0
    @memory_objects = []
    @iterations = 0
  end

  def test_stream
    puts "🔄 Starting MEMORY PRESSURE streaming test in thread #{Thread.current.object_id}"

    begin
      # Run multiple iterations with memory pressure
      3.times do |iteration|
        @iterations += 1
        puts "🔄 ITERATION #{@iterations} - Memory Pressure + Race Conditions!"

        # Create memory pressure
        create_memory_pressure

        # Create connections with race conditions
        create_memory_pressure_connections

        # Simulate streaming response with maximum pressure
        puts "📤 Simulating streaming response with memory pressure..."

        # Add precise delay to increase race condition probability
        sleep(rand(0.0001..0.001))

        puts "✅ ITERATION #{@iterations} completed"

        # Small delay between iterations
        sleep(0.1)
      end

      puts "✅ MEMORY PRESSURE streaming test completed in thread #{Thread.current.object_id}"

    rescue => e
      puts "❌ Error in memory pressure streaming test: #{e.class}: #{e.message}"
    end
  end

  def create_memory_pressure
      puts "💾 Creating memory pressure..."

      # Create memory pressure by allocating objects
      1000.times do |i|
        @memory_objects << "Memory pressure object #{i} " * 1000

        # Create some complex objects to increase memory fragmentation
        if i % 100 == 0
          @memory_objects << { complex: "object", with: "nested", data: [1, 2, 3, 4, 5] * 100 }
        end
      end

      puts "   ✅ Created #{@memory_objects.length} memory pressure objects"
    end

    def create_memory_pressure_connections
      puts "🔌 Creating MEMORY PRESSURE PostgreSQL connections..."

      # Create connections with memory pressure
      connections = []

      5.times do |i|
        conn = PG.connect(
          host: "postgres",
          port: 5432,
          dbname: "postgres",
          user: "postgres",
          password: "postgres"
        )

        connections << conn
        @total_connections += 1

        # Execute a query to keep connection active
        result = conn.exec("SELECT #{i} as connection_num, pg_backend_pid() as pid")
        puts "   ✅ Connection #{i + 1} created (PID: #{result[0]['pid']})"

      rescue => e
        puts "   ❌ Error creating connection #{i}: #{e.class}: #{e.message}"
      end

      @connections.concat(connections)

      # Simulate race conditions with memory pressure
      if connections.any?
        puts "⚠️  Simulating race conditions with memory pressure..."

        connections.each do |conn|
          # Create threads with memory pressure
          4.times do |thread_num|
            Thread.new do
              # Add memory pressure in each thread
              thread_memory = []
              100.times { |j| thread_memory << "Thread memory #{j} " * 100 }

              # PRECISE timing: wait for the exact moment
              sleep(rand(0.00001..0.0001))  # Microsecond precision

              # This is where the crash should happen: concurrent access
              conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
              puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"

              # Simulate the "double concurrent PG#close" scenario with memory pressure
              if rand < 0.8  # 80% chance of double close
                @double_close_attempts += 1
                puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"

                # Create threads trying to close the same connection with memory pressure
                4.times do |j|
                  Thread.new do
                    # Add more memory pressure in close threads
                    close_memory = []
                    50.times { |k| close_memory << "Close memory #{k} " * 100 }

                    # ULTRA PRECISE timing: this is the key to the crash
                    sleep(rand(0.000001..0.00001))  # Nanosecond precision
                    conn.close  # This should trigger the crash
                    puts "      🧹 Thread #{Thread.current.object_id} closed connection (#{j + 1})"
                  rescue => e
                    puts "      ❌ Error closing connection: #{e.class}: #{e.message}"
                  end
                end
              end

            rescue => e
              puts "   ❌ Error in race condition thread: #{e.class}: #{e.message}"
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
        double_close_attempts: @double_close_attempts,
        iterations: @iterations,
        memory_objects: @memory_objects.length
      }
    end
end

# Test the memory pressure controller
puts "🧪 Creating memory pressure test controller..."
controller = MemoryPressureTestController.new
puts "✅ Memory pressure test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts ""

# This is where the crash might happen with memory pressure + race conditions
controller.test_stream

# Wait a bit for all threads to complete
sleep(5)

puts ""
puts "📊 MEMORY PRESSURE TEST STATISTICS:"
stats = controller.get_stats
puts "   Total connections created: #{stats[:total_connections]}"
puts "   Race conditions triggered: #{stats[:race_conditions_triggered]}"
puts "   Double close attempts: #{stats[:double_close_attempts]}"
puts "   Iterations completed: #{stats[:iterations]}"
puts "   Memory objects created: #{stats[:memory_objects]}"
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
puts "🏁 Memory pressure crash test completed"
puts "This test used memory pressure + race conditions to trigger the crash!"
puts "Check the output above for any errors or core dumps"
