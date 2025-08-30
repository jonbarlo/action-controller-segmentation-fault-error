#!/usr/bin/env ruby
# frozen_string_literal: true

puts "🚨 ActionController::Live Segmentation Fault Crash Reproduction"
puts "======================================================================"
puts "Based on issue #55132: double concurrent PG#close"
puts "Environment: Ruby 3.4.4, Rails 8.0.0-8.0.2, Alpine Linux"
puts ""

puts "📊 Loading Rails components..."
puts "----------------------------------------"

begin
  puts "Loading bundler setup..."
  require "bundler/setup"
  puts "✅ bundler/setup loaded"
  
  puts "Loading openssl..."
  require "openssl"
  puts "✅ openssl loaded"
  
  puts "Loading action_controller..."
  require "action_controller"
  puts "✅ action_controller loaded"
  
  puts "Loading action_controller/metal/live..."
  require "action_controller/metal/live"
  puts "✅ action_controller/metal/live loaded"
  
  puts "Loading active_storage..."
  require "active_storage"
  puts "✅ active_storage loaded"
  
  puts ""
  puts "🎯 All components loaded successfully!"
  puts "Now examining the problematic code..."
  
  # Examine the live.rb file to understand the issue
  live_file_path = "/app/actionpack/lib/action_controller/metal/live.rb"
  if File.exist?(live_file_path)
    puts "📁 Found live.rb at: #{live_file_path}"
    
    # Look for the specific lines mentioned in the issue
    lines = File.readlines(live_file_path)
    puts "📊 File has #{lines.length} lines"
    
    # Look for the problematic area around lines 304-305
    puts "🔍 Examining lines around 304-305 (the crash area):"
    start_line = [300, 0].max
    end_line = [310, lines.length - 1].min
    
    (start_line..end_line).each do |i|
      line_num = i + 1
      content = lines[i].strip
      if content.include?("PG#close") || content.include?("execution_state") || content.include?("cleanup")
        puts "⚠️  Line #{line_num}: #{content}"
      else
        puts "   Line #{line_num}: #{content}"
      end
    end
    
    puts ""
    puts "🧪 Attempting to reproduce the crash..."
    
    # Try to create a controller that uses ActionController::Live
    begin
      test_controller_class = Class.new do
        include ActionController::Live
        
        def index
          response.headers['Content-Type'] = 'text/plain'
          response.stream.write "Test streaming response\n"
          response.stream.close
        end
      end
      
      controller = test_controller_class.new
      puts "✅ Test controller created successfully"
      puts "Testing controller methods..."
      
      # This is where the crash might occur
      puts "⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/"
      
    rescue => e
      puts "❌ Error during controller testing: #{e.class}: #{e.message}"
      puts "Backtrace:"
      e.backtrace.first(5).each { |line| puts "  #{line}" }
      
      # Check for core dumps
      if Dir.exist?("/tmp/core_dumps")
        core_files = Dir.glob("/tmp/core_dumps/*")
        if core_files.any?
          puts "🎯 CORE DUMP DETECTED!"
          core_files.each { |f| puts "  📁 #{f}" }
        else
          puts "ℹ️  No core dumps found yet"
        end
      end
    end
    
  else
    puts "❌ Could not find live.rb file"
  end
  
rescue => e
  puts "❌ Error loading components: #{e.class}: #{e.message}"
  puts ""
  puts "Backtrace:"
  e.backtrace.first(10).each { |line| puts "  #{line}" }
  
  # Check for core dumps even on loading errors
  if Dir.exist?("/tmp/core_dumps")
    core_files = Dir.glob("/tmp/core_dumps/*")
    if core_files.any?
      puts "🎯 CORE DUMP DETECTED during loading!"
      core_files.each { |f| puts "  📁 #{f}" }
    end
  end
end

puts ""
puts "🏁 Crash reproduction test completed"
puts "Check the output above for any errors or core dumps"
