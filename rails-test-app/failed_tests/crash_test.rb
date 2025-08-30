#!/usr/bin/env ruby

puts "🚨 CRASH TEST FOR CLEAN RAILS APP"
puts "=================================="
puts "Testing ActionController::Live crash reproduction"
puts ""

# Load the Rails environment
require_relative "config/environment"

puts "✅ Rails environment loaded"
puts ""

# Test the controller
puts "🧪 Testing the controller..."
puts ""

begin
  # Create a test request
  request = ActionDispatch::TestRequest.create
  controller = TestController.new
  controller.request = request
  controller.response = ActionDispatch::Response.new
  
  puts "✅ Controller created successfully"
  puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
  puts ""
  
  # This is where the crash might happen
  controller.index
  
  puts "✅ Controller test completed without crash"
  
rescue => e
  puts "❌ Controller test failed: #{e.class}: #{e.message}"
  puts "Backtrace:"
  e.backtrace.first(5).each { |line| puts "  #{line}" }
end

puts ""
puts "🔍 Checking for core dumps..."
if Dir.exist?("/tmp/core_dumps")
  core_files = Dir.glob("/tmp/core_dumps/*")
  if core_files.any?
    puts "🎯 CORE DUMP DETECTED!"
    core_files.each { |f| puts "  📁 #{f}" }
  else
    puts "ℹ️  No core dumps found"
  end
else
  puts "ℹ️  Core dump directory not found"
end

puts ""
puts "🏁 Crash test completed"
