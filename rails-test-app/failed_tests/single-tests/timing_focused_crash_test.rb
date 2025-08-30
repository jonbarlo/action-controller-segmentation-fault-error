#!/usr/bin/env ruby

puts "⏰ TIMING-FOCUSED CRASH TEST - Race Condition Precision!"
puts "========================================================"
puts "This script focuses on EXACT timing to trigger the crash"
puts "Based on issue #55132: double concurrent PG#close"
puts ""

puts "📊 Loading components..."
puts "----------------------------------------"

begin
  require "bundler/setup"
  require "openssl"
  require "rails"
  require "action_controller"
  require "action_controller/metal/live"
  require "rack"
  require "pg"
  puts "✅ All components loaded successfully"
rescue => e
  puts "❌ Error loading components: #{e.class}: #{e.message}"
  exit 1
end

puts ""
puts "🏗️  Creating Rails application..."
puts ""

# Create a minimal Rails application
app = Class.new(Rails::Application) do
  config.secret_key_base = "test_key_base_for_crash_testing"
  config.eager_load = false
  config.consider_all_requests_local = true
  config.log_level = :debug
  config.hosts << "localhost"
  config.hosts << "127.0.0.1"
end

# Initialize the app
app.initialize!

puts "✅ Rails application initialized"
puts ""

# Create a test controller that extends ActionController::Live
puts "🧪 Creating ActionController::Live test controller with PRECISE timing..."
puts ""

class TestLiveController < ActionController::Base
  include ActionController::Live
  
  def initialize
    super
    @request_count = 0
    @mutex = Mutex.new
    @connections = []
    @timing_data = []
  end
  
  def index
    @mutex.synchronize { @request_count += 1 }
    current_count = @request_count
    
    puts "🔄 HTTP Request ##{current_count} started in thread #{Thread.current.object_id}"
    
    # This is where the crash might occur - real HTTP context!
    response.headers['Content-Type'] = 'text/plain'
    response.headers['Cache-Control'] = 'no-cache'
    
    begin
      # Create PRECISE timing for race condition
      create_timing_based_pressure(current_count, Thread.current.object_id)
      
      # Simulate the problematic scenario with real response object
      response.stream.write "Processing HTTP request ##{current_count} in thread #{Thread.current.object_id}\n"
      
      # CRITICAL: Use the exact timing pattern from production
      # The crash happens when multiple threads access the same connection simultaneously
      sleep(rand(0.001..0.005))  # Ultra-precise timing: 1-5ms
      
      response.stream.write "HTTP request ##{current_count} completed in thread #{Thread.current.object_id}\n"
      response.stream.close
      
      puts "✅ HTTP Request ##{current_count} completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ HTTP Request ##{current_count} failed in thread #{Thread.current.object_id}: #{e.class}: #{e.message}"
      response.stream.close if response.stream
    end
  end
  
  private
  
  def create_timing_based_pressure(request_id, thread_id)
    begin
      # Create only 2-3 connections per request to avoid hitting limits
      connections = []
      
      # Create connections with precise timing
      3.times do |i|
        conn = PG.connect(
          host: 'postgres',
          port: 5432,
          dbname: 'postgres',
          user: 'postgres',
          password: 'postgres'
        )
        
        connections << {
          id: "#{request_id}_#{thread_id}_#{i}",
          connection: conn,
          thread: thread_id,
          created_at: Time.now,
          last_access: Time.now
        }
        
        puts "🔌 Created PostgreSQL connection #{i + 1} for request ##{request_id} in thread #{thread_id}"
        
        # Execute queries to keep connections active
        conn.exec("SELECT #{i} as connection_num, pg_backend_pid() as pid")
      end
      
      @connections.concat(connections)
      
      # CRITICAL: Simulate the EXACT race condition from production
      # The crash happens when multiple threads try to close the same connection
      if rand < 0.7  # 70% chance of conflict
        puts "⚠️  PRECISE TIMING: Simulating race condition for request ##{request_id} in thread #{thread_id}"
        
        # Create the race condition: multiple threads accessing the same connection
        connections.each do |conn_info|
          begin
            # CRITICAL: Use the exact timing that triggers the crash
            # Multiple threads will try to close connections simultaneously
            Thread.new do
              begin
                # Wait for the exact moment to create the race condition
                sleep(rand(0.0001..0.001))  # Ultra-precise: 0.1-1ms
                
                # This is where the crash should happen: concurrent access
                conn_info[:connection].exec("SELECT 1 as test")
                conn_info[:last_access] = Time.now
                
                # Simulate the "double concurrent PG#close" scenario
                if rand < 0.3  # 30% chance of double close
                  puts "   🚨 DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection #{conn_info[:id]}"
                  
                  # Create multiple threads trying to close the same connection
                  2.times do |j|
                    Thread.new do
                      begin
                        sleep(rand(0.0001..0.0005))  # Ultra-precise timing
                        conn_info[:connection].close
                        puts "      🧹 Thread #{Thread.current.object_id} closed connection #{conn_info[:id]} (#{j + 1})"
                      rescue => e
                        puts "      ❌ Thread #{Thread.current.object_id} failed to close #{conn_info[:id]}: #{e.class}: #{e.message}"
                      end
                    end
                  end
                else
                  # Keep connection open for potential conflicts
                  puts "   📌 Keeping connection #{conn_info[:id]} open for race conditions"
                end
                
              rescue => e
                puts "   ❌ Error in race condition thread: #{e.class}: #{e.message}"
              end
            end
            
          rescue => e
            puts "   ❌ Error setting up race condition: #{e.class}: #{e.message}"
          end
        end
        
        # Remove from tracking
        @connections.reject! { |c| connections.include?(c) }
      else
        # Keep connections open for maximum conflicts
        puts "   📌 Keeping connections open for race conditions"
      end
      
    rescue => e
      puts "❌ Error creating timing-based pressure: #{e.class}: #{e.message}"
    end
  end
end

puts "✅ Test controller created"
puts ""

# Create a simple Rack app
puts "🌐 Creating simple Rack application..."
puts ""

rack_app = TestLiveController.action(:index)

puts "✅ Rack application created"
puts ""

# Start a simple server using basic socket operations
puts "🚀 Starting simple HTTP server on port 3000..."
puts "⚠️  This will create PRECISE timing to trigger the race condition!"
puts ""

require "socket"
require "timeout"

# Simple HTTP server
server = TCPServer.new("0.0.0.0", 3000)
puts "✅ HTTP server is running on http://localhost:3000"
puts ""

# Server thread
server_thread = Thread.new do
  begin
    loop do
      client = server.accept
      
      Thread.new(client) do |socket|
        begin
          # Read HTTP request
          request = socket.gets
          puts "📥 Received request: #{request&.strip}"
          
          # Create a mock Rack environment
          env = {
            "REQUEST_METHOD" => "GET",
            "PATH_INFO" => "/",
            "QUERY_STRING" => "",
            "SERVER_NAME" => "localhost",
            "SERVER_PORT" => "3000",
            "HTTP_HOST" => "localhost:3000",
            "rack.input" => StringIO.new(""),
            "rack.errors" => StringIO.new(""),
            "rack.url_scheme" => "http"
          }
          
          # Call the Rack app
          status, headers, body = rack_app.call(env)
          
          # Send HTTP response
          socket.write "HTTP/1.1 #{status} OK\r\n"
          headers.each { |k, v| socket.write "#{k}: #{v}\r\n" }
          socket.write "\r\n"
          
          if body.respond_to?(:each)
            body.each { |chunk| socket.write chunk }
          else
            socket.write body.to_s
          end
          
          puts "📤 Sent response: #{status}"
          
        rescue => e
          puts "❌ Error handling request: #{e.class}: #{e.message}"
          socket.write "HTTP/1.1 500 Internal Server Error\r\n\r\nError: #{e.message}"
        ensure
          socket.close
        end
      end
    end
  rescue => e
    puts "❌ Server error: #{e.class}: #{e.message}"
  end
end

# Wait a moment for server to start
sleep(2)

# Now make concurrent HTTP requests to trigger the crash
puts "🚀 Starting PRECISE TIMING concurrent HTTP requests..."
puts "💥 This should trigger the race condition with exact timing!"
puts ""

require "net/http"
require "uri"

threads = []
request_count = 0

# Create PRECISE concurrent requests
20.times do |i|  # More threads for better race condition probability
  threads << Thread.new do
    begin
      puts "🔄 Starting HTTP client #{i + 1} (Thread ID: #{Thread.current.object_id})"
      
      # Make multiple HTTP requests per thread with precise timing
      5.times do |j|  # 5 requests per thread
        request_count += 1
        puts "  📝 Client #{i + 1} - Request #{j + 1} (Total: #{request_count})"
        
        begin
          # Make actual HTTP request
          uri = URI("http://localhost:3000/")
          http = Net::HTTP.new(uri.host, uri.port)
          http.read_timeout = 20
          
          request = Net::HTTP::Get.new(uri)
          response = http.request(request)
          
          puts "    ✅ Client #{i + 1} - Request #{j + 1} completed (Status: #{response.code})"
          
        rescue => e
          puts "    ❌ Client #{i + 1} - Request #{j + 1} failed: #{e.class}: #{e.message}"
        end
        
        # CRITICAL: Use precise timing between requests
        sleep(rand(0.001..0.003))  # 1-3ms between requests
      end
      
      puts "✅ HTTP client #{i + 1} completed successfully"
      
    rescue => e
      puts "❌ HTTP client #{i + 1} crashed: #{e.class}: #{e.message}"
      puts "   Backtrace: #{e.backtrace.first(3).join(' | ')}"
    end
  end
end

puts ""
puts "⏳ Waiting for all HTTP requests to complete..."
puts "💥 If a segmentation fault occurs, check for core dumps!"
puts ""

# Wait for all threads with timeout
begin
  Timeout.timeout(120) do  # Longer timeout for precise timing
    threads.each(&:join)
  end
  puts "✅ All HTTP requests completed without crash"
  
rescue Timeout::Error
  puts "⏰ Timeout reached - some requests may still be running"
rescue => e
  puts "💥 CRASH DETECTED: #{e.class}: #{e.message}"
end

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
puts "🛑 Stopping HTTP server..."
server.close
server_thread.kill if server_thread.alive?

puts ""
puts "🏁 Timing-focused crash test completed"
puts "If no crash occurred, the race condition may need different conditions"
puts ""
puts "💡 This test used PRECISE timing to trigger the race condition!"
puts "   The crash should occur in the C extension layer of the pg gem"
puts "   Focus: Multiple threads accessing the same connection simultaneously"
