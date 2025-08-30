#!/usr/bin/env ruby

puts "🚨 REAL POSTGRESQL CRASH TEST - Actual Database Connections!"
puts "============================================================="
puts "This script uses real PostgreSQL connections to trigger the crash"
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
  require "pg"  # The actual PostgreSQL gem that causes the crash
  puts "✅ All components loaded successfully"
rescue => e
  puts "❌ Error loading components: #{e.class}: #{e.message}"
  puts "💡 This might be the issue - the pg gem might not be available"
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

# Test PostgreSQL connection
puts "🔌 Testing PostgreSQL connection..."
puts ""

begin
  # Try to connect to PostgreSQL
  conn = PG.connect(
    host: 'postgres',
    port: 5432,
    dbname: 'postgres',
    user: 'postgres',
    password: 'postgres'
  )
  
  puts "✅ PostgreSQL connection successful"
  puts "   Connection ID: #{conn.object_id}"
  puts "   Backend PID: #{conn.backend_pid}"
  
  # Test a simple query
  result = conn.exec("SELECT 1 as test")
  puts "   Query test successful: #{result[0]['test']}"
  
  conn.close
  puts "✅ Connection closed successfully"
  
rescue => e
  puts "❌ PostgreSQL connection failed: #{e.class}: #{e.message}"
  puts "💡 This might prevent us from triggering the actual crash"
end

puts ""

# Create a test controller that extends ActionController::Live
puts "🧪 Creating ActionController::Live test controller with real PostgreSQL..."
puts ""

class TestLiveController < ActionController::Base
  include ActionController::Live
  
  def initialize
    super
    @request_count = 0
    @mutex = Mutex.new
    @connections = []
  end
  
  def index
    @mutex.synchronize { @request_count += 1 }
    current_count = @request_count
    
    puts "🔄 HTTP Request ##{current_count} started in thread #{Thread.current.object_id}"
    
    # This is where the crash might occur - real HTTP context!
    response.headers['Content-Type'] = 'text/plain'
    response.headers['Cache-Control'] = 'no-cache'
    
    begin
      # Create real PostgreSQL connections (the problematic part)
      create_postgresql_connections(current_count, Thread.current.object_id)
      
      # Simulate the problematic scenario with real response object
      response.stream.write "Processing HTTP request ##{current_count} in thread #{Thread.current.object_id}\n"
      
      # Add delay to increase race condition probability
      sleep(rand(0.05..0.2))
      
      response.stream.write "HTTP request ##{current_count} completed in thread #{Thread.current.object_id}\n"
      response.stream.close
      
      puts "✅ HTTP Request ##{current_count} completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ HTTP Request ##{current_count} failed in thread #{Thread.current.object_id}: #{e.class}: #{e.message}"
      response.stream.close if response.stream
    end
  end
  
  private
  
  def create_postgresql_connections(request_id, thread_id)
    begin
      # Create multiple connections to increase crash probability
      connections = []
      
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
          created_at: Time.now
        }
        
        puts "🔌 Created PostgreSQL connection #{i + 1} for request ##{request_id} in thread #{thread_id}"
        
        # Execute a simple query to ensure connection is active
        conn.exec("SELECT #{i} as connection_num")
      end
      
      @connections.concat(connections)
      
      # Simulate the "double concurrent PG#close" scenario
      if rand < 0.4  # 40% chance of conflict
        puts "⚠️  Simulating concurrent connection conflicts for request ##{request_id} in thread #{thread_id}"
        
        # Close connections in a way that might trigger the crash
        connections.each do |conn_info|
          begin
            conn_info[:connection].close
            puts "   🧹 Closed connection #{conn_info[:id]}"
          rescue => e
            puts "   ❌ Error closing connection #{conn_info[:id]}: #{e.class}: #{e.message}"
          end
        end
        
        # Remove from tracking
        @connections.reject! { |c| connections.include?(c) }
      else
        # Keep connections open for potential conflicts
        puts "   📌 Keeping connections open for potential conflicts"
      end
      
    rescue => e
      puts "❌ Error creating PostgreSQL connections: #{e.class}: #{e.message}"
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
puts "⚠️  This will create REAL HTTP requests with PostgreSQL connections to trigger the crash!"
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
puts "🚀 Starting concurrent HTTP requests with PostgreSQL connections..."
puts "💥 This should trigger the actual C-level crash in the pg gem!"
puts ""

require "net/http"
require "uri"

threads = []
request_count = 0

# Create concurrent requests
8.times do |i|
  threads << Thread.new do
    begin
      puts "🔄 Starting HTTP client #{i + 1} (Thread ID: #{Thread.current.object_id})"
      
      # Make multiple HTTP requests per thread
      4.times do |j|
        request_count += 1
        puts "  📝 Client #{i + 1} - Request #{j + 1} (Total: #{request_count})"
        
        begin
          # Make actual HTTP request
          uri = URI("http://localhost:3000/")
          http = Net::HTTP.new(uri.host, uri.port)
          http.read_timeout = 15
          
          request = Net::HTTP::Get.new(uri)
          response = http.request(request)
          
          puts "    ✅ Client #{i + 1} - Request #{j + 1} completed (Status: #{response.code})"
          
        rescue => e
          puts "    ❌ Client #{i + 1} - Request #{j + 1} failed: #{e.class}: #{e.message}"
        end
        
        # Small delay between requests
        sleep(rand(0.1..0.3))
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
  Timeout.timeout(60) do
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
puts "🏁 Real PostgreSQL crash test completed"
puts "If no crash occurred, the race condition may need different conditions"
puts ""
puts "💡 This test used REAL PostgreSQL connections with the pg gem!"
puts "   The crash should occur in the C extension layer of the pg gem"
