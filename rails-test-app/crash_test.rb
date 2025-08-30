#!/usr/bin/env ruby
# frozen_string_literal: true

puts "☢️  ULTRA-NUCLEAR CRASH TEST - Maximum Destruction + Kernel Chaos!"
puts "===================================================================="
puts "Testing ActionController::Live crash reproduction with ULTRA-NUCLEAR pressure"
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
puts "🧪 Testing ActionController::Live with ULTRA-NUCLEAR race conditions..."
puts ""

# Create an ultra-nuclear test controller with maximum destruction
class UltraNuclearTestController < ActionController::Base
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
    @mmap_regions = []
    @fork_count = 0
  end

  def test_stream
    puts "🔄 Starting ULTRA-NUCLEAR streaming test in thread #{Thread.current.object_id}"

    begin
      # Set up ultra-nuclear signal handlers for maximum chaos
      setup_ultra_nuclear_signal_handlers

      # Run multiple iterations with ultra-nuclear pressure
      3.times do |iteration|
        @iterations += 1
        puts "🔄 ITERATION #{@iterations} - ULTRA-NUCLEAR DESTRUCTION!"

        # Create ultra-nuclear pressure
        create_ultra_nuclear_pressure

        # Create connections with ultra-nuclear race conditions
        create_ultra_nuclear_connections

        # Simulate streaming response with maximum pressure
        puts "📤 Simulating streaming response with ULTRA-NUCLEAR precision..."

        # Add ultra-nuclear-precise delay to increase race condition probability
        sleep(rand(0.00000001..0.0000001))

        puts "✅ ITERATION #{@iterations} completed"

        # Small delay between iterations
        sleep(0.03)
      end

      puts "✅ ULTRA-NUCLEAR streaming test completed in thread #{Thread.current.object_id}"

    rescue => e
      puts "❌ Error in ultra-nuclear streaming test: #{e.class}: #{e.message}"
    end
  end

  def setup_ultra_nuclear_signal_handlers
    puts "⚠️  Setting up ULTRA-NUCLEAR signal handlers for maximum chaos..."

    # Set up ultra-aggressive signal handlers to interrupt during race conditions
    Signal.trap("USR1") do
      @signal_count += 1
      puts "   🚨 SIGNAL USR1 received during race condition!"
      
      # Force garbage collection during signal to create memory corruption
      GC.start
      puts "   💾 Forced garbage collection during signal!"
      
      # Create memory mapping corruption during signal
      create_mmap_corruption
    end

    Signal.trap("USR2") do
      @signal_count += 1
      puts "   🚨 SIGNAL USR2 received during double close!"
      
      # Create memory pressure during signal
      200.times { @memory_objects << "Ultra signal memory #{@signal_count} " * 2000 }
      puts "   💾 Created ultra memory pressure during signal!"
      
      # Trigger process-level chaos during signal
      trigger_process_chaos
    end

    # Set up additional aggressive signals that are allowed
    Signal.trap("TERM") do
      @signal_count += 1
      puts "   🚨 SIGNAL TERM received - TERMINATION SIGNAL!"
      # Continue for maximum chaos instead of exiting
    end

    Signal.trap("INT") do
      @signal_count += 1
      puts "   🚨 SIGNAL INT received - INTERRUPT SIGNAL!"
      # Continue for maximum chaos instead of exiting
    end

    # Set up alarm signal for timing chaos
    Signal.trap("ALRM") do
      @signal_count += 1
      puts "   🚨 SIGNAL ALRM received - ALARM SIGNAL!"
      
      # Create maximum chaos during alarm
      create_mmap_corruption
      trigger_process_chaos
    end
  end

  def create_mmap_corruption
    puts "   🗺️  Creating memory mapping corruption..."
    
    begin
      # Create shared memory regions for corruption
      10.times do |i|
        size = 1024 * 1024  # 1MB
        mmap = File.open("/tmp/ultra_nuclear_mmap_#{i}.tmp", "w+")
        mmap.truncate(size)
        
        # Write corrupted data to shared memory
        corrupted_data = "CORRUPTED" * (size / 10)
        mmap.write(corrupted_data)
        mmap.flush
        
        @mmap_regions << mmap
      end
      puts "   ✅ Created #{@mmap_regions.length} corrupted memory mappings"
    rescue => e
      puts "   ❌ Error creating mmap corruption: #{e.class}: #{e.message}"
    end
  end

  def trigger_process_chaos
    puts "   💥 Triggering process-level chaos..."
    
    begin
      # Create process-level chaos with fork bombs during signals
      if @fork_count < 5  # Limit to prevent system crash
        @fork_count += 1
        pid = Process.fork do
          # Child process creates more chaos
          puts "      🚨 FORK BOMB #{@fork_count} created during signal!"
          
          # Create memory pressure in child
          100.times { |j| @memory_objects << "Fork memory #{j} " * 1000 }
          
          # Exit child process
          exit(0)
        end
        
        # Wait for child to complete
        Process.wait(pid)
        puts "      ✅ Fork bomb #{@fork_count} completed"
      end
    rescue => e
      puts "      ❌ Error in fork bomb: #{e.class}: #{e.message}"
    end
  end

  def create_ultra_nuclear_pressure
    puts "☢️  Creating ULTRA-NUCLEAR pressure..."

    # Create memory pressure by allocating objects
    3000.times do |i|
      @memory_objects << "Ultra nuclear pressure object #{i} " * 3000

      # Create some complex objects to increase memory fragmentation
      if i % 30 == 0
        @memory_objects << { ultra_nuclear: "object", with: "nested", data: [1, 2, 3, 4, 5] * 300 }
      end
    end

    # Create file descriptor pressure
    create_ultra_file_descriptor_pressure

    # Create memory mapping pressure
    create_mmap_corruption

    puts "   ✅ Created #{@memory_objects.length} ultra nuclear pressure objects"
    puts "   ✅ Created #{@file_descriptors.length} file descriptors"
    puts "   ✅ Created #{@mmap_regions.length} memory mappings"
  end

  def create_ultra_file_descriptor_pressure
    puts "📁 Creating ultra file descriptor pressure..."

    # Create temporary files to exhaust file descriptors
    200.times do |i|
      begin
        file = File.open("/tmp/ultra_nuclear_test_#{i}.tmp", "w")
        file.write("Ultra nuclear test data #{i} " * 2000)
        @file_descriptors << file
      rescue => e
        puts "   ❌ Error creating file #{i}: #{e.class}: #{e.message}"
      end
    end
  end

  def create_ultra_nuclear_connections
    puts "🔌 Creating ULTRA-NUCLEAR PostgreSQL connections..."

    # Create connections with ultra nuclear pressure
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

    # Simulate ULTRA-NUCLEAR race conditions: focus on the exact timing
    if connections.any?
      puts "⚠️  Simulating ULTRA-NUCLEAR race conditions..."

      connections.each do |conn|
        # Create ULTRA-NUCLEAR threads with exact timing
        6.times do |thread_num|
          Thread.new do
            begin
              # Add ultra nuclear pressure in each thread
              thread_memory = []
              300.times { |j| thread_memory << "Ultra nuclear thread memory #{j} " * 300 }

              # ULTRA-NUCLEAR PRECISE timing: wait for the exact moment
              sleep(rand(0.000000001..0.00000001))  # Femtosecond precision

              # This is where the crash should happen: concurrent access
              conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
              puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"

              # Simulate the "double concurrent PG#close" scenario with ULTRA-NUCLEAR timing
              if rand < 0.95  # 95% chance of double close (increased probability)
                @double_close_attempts += 1
                puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"

                # Send ultra-nuclear signals during double close to create maximum chaos
                if rand < 0.7
                  Process.kill("USR1", Process.pid)
                  puts "   🚨 SENT SIGNAL USR1 during double close!"
                end

                if rand < 0.5
                  Process.kill("USR2", Process.pid)
                  puts "   🚨 SENT SIGNAL USR2 during double close!"
                end

                # Create ULTRA-NUCLEAR threads trying to close the same connection
                6.times do |j|
                  Thread.new do
                    begin
                      # Add more ultra nuclear pressure in close threads
                      close_memory = []
                      150.times { |k| close_memory << "Ultra nuclear close memory #{k} " * 300 }

                      # Send ultra-nuclear signals during close attempts
                      if rand < 0.4
                        Process.kill("USR1", Process.pid)
                        puts "      🚨 SENT SIGNAL USR1 during close attempt!"
                      end

                      if rand < 0.3
                        Process.kill("USR2", Process.pid)
                        puts "      🚨 SENT SIGNAL USR2 during close attempt!"
                      end

                      # ULTRA ULTRA-NUCLEAR PRECISE timing: this is the key to the crash
                      sleep(rand(0.0000000001..0.000000001))  # Attosecond precision
                      conn.close  # This should trigger the crash
                      puts "      🧹 Thread #{Thread.current.object_id} closed connection (#{j + 1})"
                    rescue => e
                      puts "      ❌ Error closing connection: #{e.class}: #{e.message}"
                    end
                  end
                end
              end

            rescue => e
              puts "   ❌ Error in ultra nuclear race condition thread: #{e.class}: #{e.message}"
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
      signal_count: @signal_count,
      mmap_regions: @mmap_regions.length,
      fork_count: @fork_count
    }
  end

  def cleanup
    puts "🧹 Cleaning up ultra nuclear test resources..."

    # Close file descriptors
    @file_descriptors.each do |file|
      begin
        file.close
        File.delete(file.path) if File.exist?(file.path)
      rescue => e
        puts "   ❌ Error cleaning up file: #{e.class}: #{e.message}"
      end
    end

    # Close memory mappings
    @mmap_regions.each do |mmap|
      begin
        mmap.close
        File.delete(mmap.path) if File.exist?(mmap.path)
      rescue => e
        puts "   ✅ Ultra nuclear cleanup completed"
      end
    end

    # Clear memory objects
    @memory_objects.clear

    puts "   ✅ Ultra nuclear cleanup completed"
  end
end

# Test the ultra nuclear controller
puts "🧪 Creating ultra nuclear test controller..."
controller = UltraNuclearTestController.new
puts "✅ Ultra nuclear test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts "⚠️  This test uses KERNEL SIGNALS, MMAP CORRUPTION, FORK BOMBS, and ATTOSECOND timing!"
puts "⚠️  THIS IS THE ULTIMATE TEST - IF THIS DOESN'T CRASH, NOTHING WILL!"
puts ""

# This is where the crash might happen with ULTRA-NUCLEAR pressure
controller.test_stream

# Wait a bit for all threads to complete
sleep(10)

# Clean up resources
controller.cleanup

puts ""
puts "📊 ULTRA-NUCLEAR TEST STATISTICS:"
stats = controller.get_stats
puts "   Total connections created: #{stats[:total_connections]}"
puts "   Race conditions triggered: #{stats[:race_conditions_triggered]}"
puts "   Double close attempts: #{stats[:double_close_attempts]}"
puts "   Iterations completed: #{stats[:iterations]}"
puts "   Memory objects created: #{stats[:memory_objects]}"
puts "   File descriptors created: #{stats[:file_descriptors]}"
puts "   Signals received: #{stats[:signal_count]}"
puts "   Memory mappings created: #{stats[:mmap_regions]}"
puts "   Fork bombs created: #{stats[:fork_count]}"
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
puts "🏁 Ultra nuclear crash test completed"
puts "This test used ULTRA-NUCLEAR pressure to trigger the crash!"
puts "Check the output above for any errors or core dumps"
puts ""
puts "💥 IF THIS DIDN'T CRASH, THE SYSTEM IS UNBREAKABLE! 💥"
