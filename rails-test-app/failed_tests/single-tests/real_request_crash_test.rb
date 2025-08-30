#!/usr/bin/env ruby

puts "🚨 REAL REQUEST CRASH TEST - Simulating HTTP Context"
puts "====================================================="
puts "This script creates a real Rails app context to trigger the crash"
puts "Based on issue #55132: double concurrent PG#close"
puts ""

puts "📊 Loading components in correct order..."
puts "----------------------------------------"

begin
  puts "Loading bundler setup..."
  require "bundler/setup"
  puts "✅ bundler/setup loaded"
  
  puts "Loading openssl..."
  require "openssl"
  puts "✅ openssl loaded"
  
  puts "Loading rails..."
  require "rails"
  puts "✅ rails loaded"
  
  puts "Loading action_controller..."
  require "action_controller"
  puts "✅ action_controller loaded"
  
  puts "Loading action_controller/metal/live..."
  require "action_controller/metal/live"
  puts "✅ action_controller/metal/live loaded"
  
  puts "Loading active_storage..."
  require "active_storage"
  puts "✅ active_storage loaded"
  
  puts "Loading rack..."
  require "rack"
  puts "✅ rack loaded"
  
rescue => e
  puts "❌ Error loading components: #{e.class}: #{e.message}"
  puts "Backtrace:"
  e.backtrace.first(5).each { |line| puts "  #{line}" }
  exit 1
end

puts ""
puts "🎯 All components loaded successfully!"
puts ""

# Create a minimal Rails application
puts "🏗️  Creating minimal Rails application..."
puts ""

# Create a basic app structure
app = Class.new(Rails::Application) do
  config.secret_key_base = "test_key_base_for_crash_testing"
  config.eager_load = false
  config.consider_all_requests_local = true
  config.log_level = :debug
end

# Initialize the app
app.initialize!

puts "✅ Rails application initialized"
puts ""

# Create a test controller that extends ActionController::Live
puts "🧪 Creating ActionController::Live test controller..."
puts ""

class TestLiveController < ActionController::Base
  include ActionController::Live
  
  def index
    puts "🔄 Controller action started in thread #{Thread.current.object_id}"
    
    # This is where the crash might occur
    response.headers['Content-Type'] = 'text/plain'
    response.headers['Cache-Control'] = 'no-cache'
    
    begin
      # Simulate the problematic scenario
      response.stream.write "Processing request in thread #{Thread.current.object_id}\n"
      
      # Add delay to increase race condition probability
      sleep(rand(0.1..0.3))
      
      response.stream.write "Request completed in thread #{Thread.current.object_id}\n"
      response.stream.close
      
      puts "✅ Controller action completed in thread #{Thread.current.object_id}"
      
    rescue => e
      puts "❌ Controller action failed in thread #{Thread.current.object_id}: #{e.class}: #{e.message}"
      response.stream.close if response.stream
    end
  end
end

puts "✅ Test controller created"
puts ""

# Create a Rack app to simulate HTTP requests
puts "🌐 Creating Rack application for HTTP simulation..."
puts ""

rack_app = Rack::Builder.new do
  map "/test" do
    run TestLiveController.action(:index)
  end
end

puts "✅ Rack application created"
puts ""

# Simulate concurrent HTTP requests
puts "🚀 Starting concurrent HTTP request simulation..."
puts "⚠️  This should trigger the race condition and segmentation fault!"
puts ""

threads = []
request_count = 0

5.times do |i|
  threads << Thread.new do
    begin
      puts "🔄 Starting HTTP request #{i + 1} (Thread ID: #{Thread.current.object_id})"
      
      # Simulate multiple requests per thread
      3.times do |j|
        request_count += 1
        puts "  📝 Request #{i + 1} - Call #{j + 1} (Total: #{request_count})"
        
        # Create a mock Rack environment
        env = {
          "REQUEST_METHOD" => "GET",
          "PATH_INFO" => "/test",
          "QUERY_STRING" => "",
          "SERVER_NAME" => "localhost",
          "SERVER_PORT" => "3000",
          "HTTP_HOST" => "localhost:3000",
          "rack.input" => StringIO.new(""),
          "rack.errors" => StringIO.new(""),
          "rack.url_scheme" => "http"
        }
        
        # Make the request
        status, headers, body = rack_app.call(env)
        
        puts "    ✅ Request #{i + 1} - Call #{j + 1} completed (Status: #{status})"
        
        # Small delay between requests
        sleep(0.1)
      end
      
      puts "✅ HTTP request #{i + 1} completed successfully"
      
    rescue => e
      puts "❌ HTTP request #{i + 1} crashed: #{e.class}: #{e.message}"
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
  Timeout.timeout(30) do
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
puts "🏁 Real request crash test completed"
puts "If no crash occurred, we may need to investigate further"
