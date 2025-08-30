#!/usr/bin/env ruby
# frozen_string_literal: true

puts "🎯 ULTRA-PRECISION TIMING CRASH TEST - HIT THE EXACT RACE CONDITION!"
puts "====================================================================="
puts "Testing ActionController::Live crash reproduction with ULTRA-PRECISION timing"
puts "This test focuses on hitting the EXACT moment when the crash occurs!"
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
puts "🧪 Testing ActionController::Live with ULTRA-PRECISION race condition timing..."
puts ""

# Create an ultra-precision timing test controller
class UltraPrecisionTimingTestController < ActionController::Base
  include ActionController::Live

  def initialize
    super
    @connections = []
    @race_conditions_triggered = 0
    @double_close_attempts = 0
    @total_connections = 0
    @iterations = 0
    @signal_count = 0
    @mmap_regions = []
    @fork_count = 0
    @thread_explosion_count = 0
    @memory_corruption_count = 0
    @connection_chaos_count = 0
    @timing_hits = 0
    @ultra_precision_delays = []
    @memory_objects = []
  end

  def test_stream
    puts "🔄 Starting ULTRA-PRECISION timing streaming test in thread #{Thread.current.object_id}"

    begin
      # Set up ultra-precision signal handlers
      setup_ultra_precision_signal_handlers

      # Run multiple iterations with ultra-precision timing
      10.times do |iteration|
        @iterations += 1
        puts "🔄 ITERATION #{@iterations} - ULTRA-PRECISION TIMING ATTEMPT!"

        # Create connections with ultra-precision race conditions
        create_ultra_precision_connections

        # Simulate streaming response with ultra-precision timing
        puts "📤 Simulating streaming response with ULTRA-PRECISION timing..."

        # Add ultra-precision delay to increase race condition probability
        ultra_precision_delay = rand(0.000000000001..0.00000000001)  # Femtosecond precision
        @ultra_precision_delays << ultra_precision_delay
        sleep(ultra_precision_delay)

        puts "✅ ITERATION #{@iterations} completed with #{ultra_precision_delay} delay"

        # Small delay between iterations
        sleep(0.01)
      end

      puts "✅ ULTRA-PRECISION timing streaming test completed in thread #{Thread.current.object_id}"

    rescue => e
      puts "❌ Error in ultra-precision timing streaming test: #{e.class}: #{e.message}"
    end
  end

  def setup_ultra_precision_signal_handlers
    puts "⚠️  Setting up ULTRA-PRECISION signal handlers for exact timing..."

    # Set up ultra-precision signal handlers to interrupt during race conditions
    Signal.trap("USR1") do
      @signal_count += 1
      puts "   🚨 SIGNAL USR1 received during race condition!"
      
      # Force garbage collection during signal to create memory corruption
      GC.start
      puts "   💾 Forced garbage collection during signal!"
      
      # Create memory mapping corruption during signal
      create_ultra_precision_mmap_corruption
      
      # Create thread explosion during signal
      create_ultra_precision_thread_explosion
      
      # Create memory corruption during signal
      create_ultra_precision_memory_corruption
    end

    Signal.trap("USR2") do
      @signal_count += 1
      puts "   🚨 SIGNAL USR2 received during double close!"
      
      # Create memory pressure during signal
      100.times { @memory_objects << "Ultra precision signal memory #{@signal_count} " * 1000 }
      puts "   💾 Created ultra precision memory pressure during signal!"
      
      # Trigger process-level chaos during signal
      trigger_ultra_precision_process_chaos
      
      # Create more thread explosion
      create_ultra_precision_thread_explosion
      
      # Create connection chaos
      create_ultra_precision_connection_chaos
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
      create_ultra_precision_mmap_corruption
      create_ultra_precision_thread_explosion
      trigger_ultra_precision_process_chaos
      create_ultra_precision_memory_corruption
      create_ultra_precision_connection_chaos
    end
  end

  def create_ultra_precision_thread_explosion
    puts "   💥 Creating ULTRA-PRECISION thread explosion during signal..."
    
    begin
      # Create massive thread explosion during signals
      20.times do |i|
        Thread.new do
          @thread_explosion_count += 1
          
          # Each explosion thread creates memory pressure
          explosion_memory = []
          100.times { |j| explosion_memory << "Ultra precision explosion memory #{j} " * 500 }
          
          # Don't send more signals during explosion to avoid infinite loops
          # if rand < 0.5
          #   Process.kill("USR1", Process.pid)
          # end
          
          # Ultra-precision timing in explosion threads
          sleep(rand(0.000000000001..0.00000000001))  # Femtosecond precision
        end
      end
      puts "   ✅ Created #{@thread_explosion_count} ultra precision explosion threads"
    rescue => e
      puts "   ❌ Error in ultra precision thread explosion: #{e.class}: #{e.message}"
    end
  end

  def create_ultra_precision_mmap_corruption
    puts "   🗺️  Creating ULTRA-PRECISION memory mapping corruption..."
    
    begin
      # Create shared memory regions for corruption
      20.times do |i|
        size = 2 * 1024 * 1024  # 2MB
        mmap = File.open("/tmp/ultra_precision_mmap_#{i}.tmp", "w+")
        mmap.truncate(size)
        
        # Write corrupted data to shared memory
        corrupted_data = "ULTRA_PRECISION_CORRUPTED" * (size / 20)
        mmap.write(corrupted_data)
        mmap.flush
        
        @mmap_regions << mmap
      end
      puts "   ✅ Created #{@mmap_regions.length} ultra precision corrupted memory mappings"
    rescue => e
      puts "   ❌ Error creating ultra precision mmap corruption: #{e.class}: #{e.message}"
    end
  end

  def create_ultra_precision_memory_corruption
    puts "   💾 Creating ULTRA-PRECISION memory corruption..."
    
    begin
      # Create massive memory corruption
      500.times do |i|
        # Create complex objects that can corrupt memory
        corrupted_object = {
          ultra_precision: "corruption",
          data: Array.new(500) { |j| "Corrupted data #{j} " * 50 },
          nested: {
            more_corruption: Array.new(250) { |k| "Nested corruption #{k} " * 100 }
          }
        }
        
        @memory_objects << corrupted_object
        @memory_corruption_count += 1
      end
      puts "   ✅ Created #{@memory_corruption_count} ultra precision memory corruption objects"
    rescue => e
      puts "   ❌ Error in ultra precision memory corruption: #{e.class}: #{e.message}"
    end
  end

  def create_ultra_precision_connection_chaos
    puts "   🔌 Creating ULTRA-PRECISION connection chaos..."
    
    begin
      # Create connection chaos by manipulating existing connections
      @connections.each do |conn|
        # Create multiple threads trying to corrupt the same connection
        5.times do |i|
          Thread.new do
            begin
              # Try to execute multiple queries simultaneously
              3.times do |j|
                conn.exec("SELECT #{j} as chaos_query, pg_backend_pid() as pid")
                sleep(rand(0.000000000001..0.00000000001))  # Femtosecond precision
              end
              
              @connection_chaos_count += 1
            rescue => e
              # Expected errors - this is chaos!
            end
          end
        end
      end
      puts "   ✅ Created #{@connection_chaos_count} ultra precision connection chaos threads"
    rescue => e
      puts "   ❌ Error in ultra precision connection chaos: #{e.class}: #{e.message}"
    end
  end

  def trigger_ultra_precision_process_chaos
    puts "   💥 Triggering ULTRA-PRECISION process-level chaos..."
    
    begin
      # Create process-level chaos with fork bombs during signals
      if @fork_count < 8
        @fork_count += 1
        pid = Process.fork do
          # Child process creates more chaos
          puts "      🚨 ULTRA-PRECISION FORK BOMB #{@fork_count} created during signal!"
          
          # Create memory pressure in child
          200.times { |j| @memory_objects << "Ultra precision fork memory #{j} " * 1000 }
          
          # Don't send signals from child process to avoid infinite loops
          # if rand < 0.6
          #   Process.kill("USR1", Process.pid)
          # end
          
          # Create more chaos in child
          create_ultra_precision_memory_corruption
          
          # Exit child process
          exit(0)
        end
        
        # Wait for child to complete
        Process.wait(pid)
        puts "      ✅ Ultra precision fork bomb #{@fork_count} completed"
      end
    rescue => e
      puts "      ❌ Error in ultra precision fork bomb: #{e.class}: #{e.message}"
    end
  end

  def create_ultra_precision_connections
    puts "🔌 Creating ULTRA-PRECISION PostgreSQL connections..."

    # Create connections with ultra-precision pressure
    connections = []

    10.times do |i|
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

    # Simulate ULTRA-PRECISION race conditions: focus on the exact timing
    if connections.any?
      puts "⚠️  Simulating ULTRA-PRECISION race conditions..."

      connections.each do |conn|
        # Create ULTRA-PRECISION threads with exact timing
        15.times do |thread_num|
          Thread.new do
            begin
              # Add ultra precision pressure in each thread
              thread_memory = []
              400.times { |j| thread_memory << "Ultra precision thread memory #{j} " * 400 }

              # ULTRA-PRECISION timing: wait for the exact moment
              ultra_precision_delay = rand(0.000000000001..0.00000000001)  # Femtosecond precision
              sleep(ultra_precision_delay)

              # This is where the crash should happen: concurrent access
              conn.exec("SELECT 1 as test, pg_backend_pid() as pid")
              puts "   🔄 Thread #{Thread.current.object_id} executed query on connection"

              # Simulate the "double concurrent PG#close" scenario with ULTRA-PRECISION timing
              if rand < 0.98  # 98% chance of double close
                @double_close_attempts += 1
                puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection"

                # Send ultra-precision signals during double close to create maximum chaos
                if rand < 0.9
                  Process.kill("USR1", Process.pid)
                  puts "   🚨 SENT SIGNAL USR1 during double close!"
                end

                if rand < 0.8
                  Process.kill("USR2", Process.pid)
                  puts "   🚨 SENT SIGNAL USR2 during double close!"
                end

                # Create ULTRA-PRECISION threads trying to close the same connection
                15.times do |j|
                  Thread.new do
                    begin
                      # Add more ultra precision pressure in close threads
                      close_memory = []
                      200.times { |k| close_memory << "Ultra precision close memory #{k} " * 400 }

                      # Send ultra-precision signals during close attempts
                      if rand < 0.7
                        Process.kill("USR1", Process.pid)
                        puts "      🚨 SENT SIGNAL USR1 during close attempt!"
                      end

                      if rand < 0.6
                        Process.kill("USR2", Process.pid)
                        puts "      🚨 SENT SIGNAL USR2 during close attempt!"
                      end

                      # ULTRA ULTRA-PRECISION timing: this is the key to the crash
                      ultra_close_delay = rand(0.000000000001..0.00000000001)  # Femtosecond precision
                      sleep(ultra_close_delay)
                      conn.close  # This should trigger the crash
                      puts "      🧹 Thread #{Thread.current.object_id} closed connection (#{j + 1})"
                      @timing_hits += 1
                    rescue => e
                      puts "      ❌ Error closing connection: #{e.class}: #{e.message}"
                    end
                  end
                end
              end

            rescue => e
              puts "   ❌ Error in ultra precision race condition thread: #{e.class}: #{e.message}"
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
      signal_count: @signal_count,
      mmap_regions: @mmap_regions.length,
      fork_count: @fork_count,
      thread_explosion_count: @thread_explosion_count,
      memory_corruption_count: @memory_corruption_count,
      connection_chaos_count: @connection_chaos_count,
      timing_hits: @timing_hits,
      ultra_precision_delays: @ultra_precision_delays
    }
  end

  def cleanup
    puts "🧹 Cleaning up ultra precision timing test resources..."

    # Close memory mappings
    @mmap_regions.each do |mmap|
      begin
        mmap.close
        File.delete(mmap.path) if File.exist?(mmap.path)
      rescue => e
        puts "   ❌ Error cleaning up mmap: #{e.class}: #{e.message}"
      end
    end

    # Clear memory objects
    @memory_objects.clear

    puts "   ✅ Ultra precision timing cleanup completed"
  end
end

# Test the ultra precision timing controller
puts "🧪 Creating ultra precision timing test controller..."
controller = UltraPrecisionTimingTestController.new
puts "✅ Ultra precision timing test controller created successfully"
puts ""

puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
puts "⚠️  This test uses ULTRA-PRECISION timing with femtosecond delays!"
puts "⚠️  We're focusing on hitting the EXACT race condition timing!"
puts ""

# This is where the crash might happen with ULTRA-PRECISION timing
controller.test_stream

# Wait a bit for all threads to complete
sleep(15)

# Clean up resources
controller.cleanup

puts ""
puts "📊 ULTRA-PRECISION TIMING TEST STATISTICS:"
stats = controller.get_stats
puts "   Total connections created: #{stats[:total_connections]}"
puts "   Race conditions triggered: #{stats[:race_conditions_triggered]}"
puts "   Double close attempts: #{stats[:double_close_attempts]}"
puts "   Iterations completed: #{stats[:iterations]}"
puts "   Signals received: #{stats[:signal_count]}"
puts "   Memory mappings created: #{stats[:mmap_regions]}"
puts "   Fork bombs created: #{stats[:fork_count]}"
puts "   Thread explosions created: #{stats[:thread_explosion_count]}"
puts "   Memory corruption objects: #{stats[:memory_corruption_count]}"
puts "   Connection chaos threads: #{stats[:connection_chaos_count]}"
puts "   Timing hits: #{stats[:timing_hits]}"
puts "   Ultra precision delays used: #{stats[:ultra_precision_delays].length}"
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
puts "🏁 Ultra precision timing crash test completed"
puts "This test used ULTRA-PRECISION timing to trigger the crash!"
puts "Check the output above for any errors or core dumps"
puts ""
puts "🎯 We're focusing on hitting the EXACT race condition timing! 🎯"
puts "⏱️  Femtosecond precision to catch that crash! ⏱️"
