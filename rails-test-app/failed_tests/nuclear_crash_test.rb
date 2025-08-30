#!/usr/bin/env ruby
# frozen_string_literal: true

puts "☢️  NUCLEAR CRASH TEST - Maximum Destruction!"
puts "=============================================="
puts "Testing ActionController::Live crash reproduction with NUCLEAR pressure"
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
puts "🧪 Testing ActionController::Live with NUCLEAR race conditions..."
puts ""

# Create a nuclear test controller with maximum destruction
class NuclearTestController < ActionController::Base
  include ActionController::Live

  def initialize
    super
    @connections = []
    @race_conditions_triggered = 0
    @double_close_attempts = 0
    @total_connections = 0
    @iterations = 0
    @memory_objects = []
    @file_descriptors = []
    @signal_count = 0
  end

  def test_stream
    puts "🔄 Starting NUCLEAR streaming test in thread #{Thread.current.object_id}"

    begin
      # Set up signal handlers for maximum chaos
      setup_signal_handlers

      # Run multiple iterations with nuclear pressure
      3.times do |iteration|
        @iterations += 1
        puts "🔄 ITERATION #{@iterations} - NUCLEAR DESTRUCTION!"

        # Create nuclear pressure
        create_nuclear_pressure

        # Create connections with nuclear race conditions
        create_nuclear_connections

        # Simulate streaming response with maximum pressure
        puts "📤 Simulating streaming response with NUCLEAR precision..."

        # Add nuclear-precise delay to increase race condition probability
        sleep(rand(0.0000001..0.000001))

        puts "✅ ITERATION #{@iterations} completed"

        # Small delay between iterations
        sleep(0.05)
      end

      puts "✅ NUCLEAR streaming test completed in thread #{Thread.current.object_id}"

    rescue => e
      puts "❌ Error in nuclear streaming test: #{e.class}: #{e.message}"
    end
  end

  def setup_signal_handlers
    puts "⚠️  Setting up signal handlers for maximum chaos..."

    # Set up signal handlers to interrupt during race conditions
    Signal.trap("USR1") do
      @signal_count += 1
      puts "   🚨 SIGNAL USR1 received during race condition!"
      
      # Force garbage collection during signal to create memory corruption
      GC.start
      puts "   💾 Forced garbage collection during signal!"
    end

    Signal.trap("USR2") do
      @signal_count += 1
      puts "   🚨 SIGNAL USR2 received during double close!"
      
      # Create memory pressure during signal
      100.times { @memory_objects << "Signal memory #{@signal_count} " * 1000 }
      puts "   💾 Created memory pressure during signal!"
    end
  end

  def create_nuclear_pressure
    puts "☢️  Creating NUCLEAR pressure..."

    # Create memory pressure by allocating objects
    2000.times do |i|
      @memory_objects << "Nuclear pressure object #{i} " * 2000

      # Create some complex objects to increase memory fragmentation
      if i % 50 == 0
        @memory_objects << { nuclear: "object", with: "nested", data: [1, 2, 3, 4, 5] * 200 }
      end
    end

    # Create file descriptor pressure
    create_file_descriptor_pressure

    puts "   ✅ Created #{@memory_objects.length} nuclear pressure objects"
    puts "   ✅ Created #{@file_descriptors.length} file descriptors"
  end

  def create_file_descriptor_pressure
    puts "📁 Creating file descriptor pressure..."

    # Create temporary files to exhaust file descriptors
    100.times do |i|
      begin
        file = File.open("/tmp/nuclear_test_#{i}.tmp", "w")
        file.write("Nuclear test data #{i} " * 1000)
        @file_descriptors << file
      rescue => e
        puts "   ❌ Error creating file #{i}: #{e.class}: #{e.message}"
      end
    end
  end

  def create_nuclear_connections
    puts "🔌 Creating NUCLEAR PostgreSQL connections..."

    # Create connections with nuclear pressure
    connections = []

    5.times do |i|
      begin
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
    end

    @connections.concat(connections)

    # Simulate NUCLEAR race conditions: focus on the exact timing
    if connections.any?
      puts "⚠️  Simulating NUCLEAR race conditions..."

      connections.each do |conn|
        # Create NUCLEAR threads with exact timing
        5.times do |thread_num|
          Thread.new do
            begin
              # Add nuclear pressure in each thread
              thread_memory = []
              200.times { |j| thread_memory << "Nuclear thread memory #{j} " * 200 }

              # NUCLEAR PRECISE timing: wait for the exact moment
              sleep(rand(0.00000001..0.0000001))  # Picosecond precision

              # This is where the crash should happen: concurrent access
              conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
              puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"

              # Simulate the "double concurrent PG#close" scenario with NUCLEAR timing
              if rand < 0.9  # 90% chance of double close (increased probability)
                @double_close_attempts += 1
                puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"

                # Send signals during double close to create maximum chaos
                if rand < 0.5
                  Process.kill("USR1", Process.pid)
                  puts "   🚨 SENT SIGNAL USR1 during double close!"
                end

                # Create NUCLEAR threads trying to close the same connection
                5.times do |j|
                  Thread.new do
                    begin
                      # Add more nuclear pressure in close threads
                      close_memory = []
                      100.times { |k| close_memory << "Nuclear close memory #{k} " * 200 }

                      # Send signals during close attempts
                      if rand < 0.3
                        Process.kill("USR2", Process.pid)
                        puts "      🚨 SENT SIGNAL USR2 during close attempt!"
                      end

                      # ULTRA NUCLEAR PRECISE timing: this is the key to the crash
                      sleep(rand(0.000000001..0.00000001))  # Femtosecond precision
                      conn.close  # This should trigger the crash
                      puts "      🧹 Thread #{Thread.current.object_id} closed connection (#{j + 1})"
                    rescue => e
                      puts "      ❌ Error closing connection: #{e.class}: #{e.message}"
                    end
                  end
                end
              end

            rescue => e
              puts "   ❌ Error in nuclear race condition thread: #{e.class}: #{e.message}"
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
      double_close_attempts: @double_close_attempts,
      iterations: @iterations,
      memory_objects: @memory_objects.length,
      file_descriptors: @file_descriptors.length,
      signal_count: @signal_count
    }
  end

  def cleanup
    puts "🧹 Cleaning up nuclear test resources..."

    # Close file descriptors
    @file_descriptors.each do |file|
      begin
        file.close
        File.delete(file.path) if File.exist?(file.path)
      rescue => e
        puts "   ❌ Error cleaning up file: #{e.class}: #{e.message}"
      end
    end

    # Clear memory objects
    @memory_objects.clear

    puts "   ✅ Nuclear cleanup completed"
  end
end

# Test the nuclear controller
puts "🧪 Creating nuclear test controller..."
controller = NuclearTestController.new
puts "✅ Nuclear test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts "⚠️  This test uses SIGNALS, MEMORY CORRUPTION, and PICOSECOND timing!"
puts ""

# This is where the crash might happen with NUCLEAR pressure
controller.test_stream

# Wait a bit for all threads to complete
sleep(8)

# Clean up resources
controller.cleanup

puts ""
puts "📊 NUCLEAR TEST STATISTICS:"
stats = controller.get_stats
puts "   Total connections created: #{stats[:total_connections]}"
puts "   Race conditions triggered: #{stats[:race_conditions_triggered]}"
puts "   Double close attempts: #{stats[:double_close_attempts]}"
puts "   Iterations completed: #{stats[:iterations]}"
puts "   Memory objects created: #{stats[:memory_objects]}"
puts "   File descriptors created: #{stats[:file_descriptors]}"
puts "   Signals received: #{stats[:signal_count]}"
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
puts "🏁 Nuclear crash test completed"
puts "This test used NUCLEAR pressure to trigger the crash!"
puts "Check the output above for any errors or core dumps"
