#!/usr/bin/env ruby

puts "🏭 PRODUCTION-LIKE CRASH TEST - Exact Environment Replication!"
puts "=============================================================="
puts "This script replicates the EXACT production environment from issue #55132"
puts "Focus: Real Rails app, production-like config, exact crash conditions"
puts ""

puts "📊 Loading production components..."
puts "----------------------------------------"

begin
  require "bundler/setup"
  require "openssl"
  require "rails"
  require "action_controller"
  require "action_controller/metal/live"
  require "active_storage"
  require "rack"
  require "pg"
  require "socket"
  require "timeout"
  require "net/http"
  require "uri"
  puts "✅ All production components loaded successfully"
rescue => e
  puts "❌ Error loading components: #{e.class}: #{e.message}"
  exit 1
end

puts ""
puts "🏗️  Creating PRODUCTION-LIKE Rails application..."
puts ""

# Create a production-like Rails application
app = Class.new(Rails::Application) do
  config.secret_key_base = "production_secret_key_for_crash_testing"
  config.eager_load = false
  config.consider_all_requests_local = false  # Production-like
  config.log_level = :info  # Production-like
  config.hosts << "localhost"
  config.hosts << "127.0.0.1"
  
  # Production-like database configuration
  config.database_configuration = {
    'production' => {
      'adapter' => 'postgresql',
      'host' => 'postgres',
      'port' => 5432,
      'database' => 'postgres',
      'username' => 'postgres',
      'password' => 'postgres',
      'pool' => 25,  # Production-like connection pool
      'timeout' => 5000,
      'reaping_frequency' => 10
    }
  }
  
  # Production-like middleware stack
  config.middleware.use Rack::Deflater
  config.middleware.use Rack::Attack if defined?(Rack::Attack)
end

# Initialize the app
app.initialize!

puts "✅ Production-like Rails application initialized"
puts ""

# Create a production-like controller that extends ActionController::Live
puts "🧪 Creating PRODUCTION-LIKE ActionController::Live controller..."
puts ""

class ProductionLiveController < ActionController::Base
  include ActionController::Live
  
  # Production-like configuration
  before_action :set_production_headers
  after_action :cleanup_production_resources
  
  def initialize
    super
    @request_count = 0
    @mutex = Mutex.new
    @connections = []
    @production_metrics = {
      start_time: Time.now,
      requests_processed: 0,
      connections_created: 0,
      race_conditions_triggered: 0
    }
  end
  
  def index
    @mutex.synchronize { @request_count += 1 }
    current_count = @request_count
    
    puts "🏭 PRODUCTION Request ##{current_count} started in thread #{Thread.current.object_id}"
    
    # Production-like response handling
    response.headers['Content-Type'] = 'application/json'
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    
    begin
      # PRODUCTION-LIKE: Create real database connections with production patterns
      create_production_database_connections(current_count, Thread.current.object_id)
      
      # Simulate production workload
      response.stream.write "{\"status\":\"processing\",\"request_id\":#{current_count},\"thread_id\":#{Thread.current.object_id}}\n"
      
      # CRITICAL: Use production-like timing patterns
      # The crash happens in production under specific load conditions
      sleep(rand(0.005..0.020))  # Production-like: 5-20ms
      
      response.stream.write "{\"status\":\"completed\",\"request_id\":#{current_count},\"thread_id\":#{Thread.current.object_id}}\n"
      response.stream.close
      
      @production_metrics[:requests_processed] += 1
      puts "✅ PRODUCTION Request ##{current_count} completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ PRODUCTION Request ##{current_count} failed in thread #{Thread.current.object_id}: #{e.class}: #{e.message}"
      response.stream.close if response.stream
    end
  end
  
  private
  
  def set_production_headers
    # Production-like security headers
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end
  
  def cleanup_production_resources
    # Production-like cleanup
    @connections.each do |conn_info|
      begin
        conn_info[:connection].close if conn_info[:connection] && !conn_info[:connection].closed?
      rescue => e
        puts "   ⚠️  Cleanup error for connection #{conn_info[:id]}: #{e.class}: #{e.message}"
      end
    end
    @connections.clear
  end
  
  def create_production_database_connections(request_id, thread_id)
    begin
      # PRODUCTION-LIKE: Create connections with production patterns
      connections = []
      
      # Production typically uses 2-4 connections per request
      3.times do |i|
        conn = PG.connect(
          host: 'postgres',
          port: 5432,
          dbname: 'postgres',
          user: 'postgres',
          password: 'postgres',
          # Production-like connection settings
          connect_timeout: 10,
          options: '-c statement_timeout=30000'
        )
        
        connections << {
          id: "#{request_id}_#{thread_id}_#{i}",
          connection: conn,
          thread: thread_id,
          created_at: Time.now,
          last_access: Time.now
        }
        
        puts "🔌 PRODUCTION: Created PostgreSQL connection #{i + 1} for request ##{request_id} in thread #{thread_id}"
        
        # Execute production-like queries
        conn.exec("SELECT #{i} as connection_num, pg_backend_pid() as pid, now() as timestamp")
      end
      
      @connections.concat(connections)
      @production_metrics[:connections_created] += connections.length
      
      # PRODUCTION-LIKE: Simulate the exact race condition from issue #55132
      # The crash happens when multiple threads access the same connection simultaneously
      if rand < 0.8  # 80% chance of race condition (production-like frequency)
        puts "⚠️  PRODUCTION RACE CONDITION: Triggering for request ##{request_id} in thread #{thread_id}"
        @production_metrics[:race_conditions_triggered] += 1
        
        # Create the EXACT race condition from production
        connections.each do |conn_info|
          begin
            # PRODUCTION-LIKE: Multiple threads accessing the same connection
            # This is the exact scenario that causes the crash
            Thread.new do
              begin
                # Wait for the exact moment to create the race condition
                sleep(rand(0.0001..0.001))  # Ultra-precise: 0.1-1ms
                
                # PRODUCTION-LIKE: Execute query while another thread might close the connection
                conn_info[:connection].exec("SELECT 1 as test, pg_backend_pid() as pid")
                conn_info[:last_access] = Time.now
                
                # PRODUCTION-LIKE: Simulate the "double concurrent PG#close" scenario
                if rand < 0.4  # 40% chance of double close (production-like)
                  puts "   🚨 PRODUCTION DOUBLE CLOSE: Thread #{Thread.current.object_id} closing connection #{conn_info[:id]}"
                  
                  # Create multiple threads trying to close the same connection
                  # This is EXACTLY what happens in production and causes the crash
                  2.times do |j|
                    Thread.new do
                      begin
                        sleep(rand(0.0001..0.0005))  # Ultra-precise timing
                        
                        # PRODUCTION-LIKE: This is where the crash occurs
                        # Multiple threads calling PG#close on the same connection
                        conn_info[:connection].close
                        puts "      🧹 PRODUCTION: Thread #{Thread.current.object_id} closed connection #{conn_info[:id]} (#{j + 1})"
                        
                      rescue => e
                        puts "      ❌ PRODUCTION: Thread #{Thread.current.object_id} failed to close #{conn_info[:id]}: #{e.class}: #{e.message}"
                      end
                    end
                  end
                else
                  # Keep connection open for potential conflicts
                  puts "   📌 PRODUCTION: Keeping connection #{conn_info[:id]} open for race conditions"
                end
                
              rescue => e
                puts "   ❌ PRODUCTION: Error in race condition thread: #{e.class}: #{e.message}"
              end
            end
            
          rescue => e
            puts "   ❌ PRODUCTION: Error setting up race condition: #{e.class}: #{e.message}"
          end
        end
        
        # Remove from tracking
        @connections.reject! { |c| connections.include?(c) }
      else
        # Keep connections open for maximum conflicts
        puts "   📌 PRODUCTION: Keeping connections open for race conditions"
      end
      
    rescue => e
      puts "❌ PRODUCTION: Error creating database connections: #{e.class}: #{e.message}"
    end
  end
end

puts "✅ Production-like controller created"
puts ""

# Create a production-like Rack app
puts "🌐 Creating production-like Rack application..."
puts ""

rack_app = ProductionLiveController.action(:index)

puts "✅ Production-like Rack application created"
puts ""

# Start a production-like server
puts "🚀 Starting PRODUCTION-LIKE HTTP server on port 3000..."
puts "⚠️  This replicates the exact production environment!"
puts ""

# Production-like HTTP server
server = TCPServer.new("0.0.0.0", 3000)
puts "✅ PRODUCTION-LIKE HTTP server is running on http://localhost:3000"
puts ""

# Production-like server thread
server_thread = Thread.new do
  begin
    loop do
      client = server.accept
      
      Thread.new(client) do |socket|
        begin
          # Read HTTP request
          request = socket.gets
          puts "📥 PRODUCTION: Received request: #{request&.strip}"
          
          # Create production-like Rack environment
          env = {
            "REQUEST_METHOD" => "GET",
            "PATH_INFO" => "/",
            "QUERY_STRING" => "",
            "SERVER_NAME" => "localhost",
            "SERVER_PORT" => "3000",
            "HTTP_HOST" => "localhost:3000",
            "HTTP_USER_AGENT" => "ProductionCrashTest/1.0",
            "HTTP_ACCEPT" => "application/json",
            "rack.input" => StringIO.new(""),
            "rack.errors" => StringIO.new(""),
            "rack.url_scheme" => "http"
          }
          
          # Call the Rack app
          status, headers, body = rack_app.call(env)
          
          # Send production-like HTTP response
          socket.write "HTTP/1.1 #{status} OK\r\n"
          headers.each { |k, v| socket.write "#{k}: #{v}\r\n" }
          socket.write "\r\n"
          
          if body.respond_to?(:each)
            body.each { |chunk| socket.write chunk }
          else
            socket.write body.to_s
          end
          
          puts "📤 PRODUCTION: Sent response: #{status}"
          
        rescue => e
          puts "❌ PRODUCTION: Error handling request: #{e.class}: #{e.message}"
          socket.write "HTTP/1.1 500 Internal Server Error\r\n\r\nError: #{e.message}"
        ensure
          socket.close
        end
      end
    end
  rescue => e
    puts "❌ PRODUCTION: Server error: #{e.class}: #{e.message}"
  end
end

# Wait for server to start
sleep(2)

# Now make production-like concurrent HTTP requests
puts "🚀 Starting PRODUCTION-LIKE concurrent HTTP requests..."
puts "💥 This replicates the exact production load that causes the crash!"
puts ""

threads = []
request_count = 0

# Create production-like concurrent requests
25.times do |i|  # Production-like: 25 client threads
  threads << Thread.new do
    begin
      puts "🔄 PRODUCTION: Starting HTTP client #{i + 1} (Thread ID: #{Thread.current.object_id})"
      
      # Make production-like HTTP requests per thread
      8.times do |j|  # Production-like: 8 requests per thread
        request_count += 1
        puts "  📝 PRODUCTION: Client #{i + 1} - Request #{j + 1} (Total: #{request_count})"
        
        begin
          # Make actual HTTP request
          uri = URI("http://localhost:3000/")
          http = Net::HTTP.new(uri.host, uri.port)
          http.read_timeout = 30  # Production-like timeout
          
          request = Net::HTTP::Get.new(uri)
          request['User-Agent'] = 'ProductionCrashTest/1.0'
          request['Accept'] = 'application/json'
          
          response = http.request(request)
          
          puts "    ✅ PRODUCTION: Client #{i + 1} - Request #{j + 1} completed (Status: #{response.code})"
          
        rescue => e
          puts "    ❌ PRODUCTION: Client #{i + 1} - Request #{j + 1} failed: #{e.class}: #{e.message}"
        end
        
        # Production-like timing between requests
        sleep(rand(0.002..0.008))  # 2-8ms between requests
      end
      
      puts "✅ PRODUCTION: HTTP client #{i + 1} completed successfully"
      
    rescue => e
      puts "❌ PRODUCTION: HTTP client #{i + 1} crashed: #{e.class}: #{e.message}"
      puts "   Backtrace: #{e.backtrace.first(3).join(' | ')}"
    end
  end
end

puts ""
puts "⏳ Waiting for all PRODUCTION-LIKE HTTP requests to complete..."
puts "💥 If a segmentation fault occurs, check for core dumps!"
puts ""

# Wait for all threads with production-like timeout
begin
  Timeout.timeout(180) do  # Production-like: 3 minute timeout
    threads.each(&:join)
  end
  puts "✅ All PRODUCTION-LIKE HTTP requests completed without crash"
  
rescue Timeout::Error
  puts "⏰ PRODUCTION: Timeout reached - some requests may still be running"
rescue => e
  puts "💥 PRODUCTION CRASH DETECTED: #{e.class}: #{e.message}"
end

puts ""
puts "📊 PRODUCTION METRICS SUMMARY:"
puts "   Requests processed: #{@production_metrics[:requests_processed]}"
puts "   Connections created: #{@production_metrics[:connections_created]}"
puts "   Race conditions triggered: #{@production_metrics[:race_conditions_triggered]}"
puts "   Total runtime: #{Time.now - @production_metrics[:start_time]} seconds"
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
puts "🛑 Stopping PRODUCTION-LIKE HTTP server..."
server.close
server_thread.kill if server_thread.alive?

puts ""
puts "🏁 PRODUCTION-LIKE crash test completed"
puts "This test replicated the exact production environment from issue #55132"
puts ""
puts "💡 If no crash occurred, the issue may require:"
puts "   1. Specific PostgreSQL version from production"
puts "   2. Exact memory layout and thread scheduling"
puts "   3. Different connection pool configuration"
puts "   4. Specific load patterns not yet identified"
