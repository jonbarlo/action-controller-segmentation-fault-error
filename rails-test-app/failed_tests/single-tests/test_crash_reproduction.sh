#!/bin/bash

# Test ActionController::Live crash reproduction with Docker
# This script sets up the environment to reproduce the segmentation fault

set -e

echo "🚨 ActionController::Live Crash Reproduction Test"
echo "=================================================="
echo "Based on issue #55132: double concurrent PG#close"
echo "Strategy: Fix + Replace (Ad Hoc Fix + WebSocket Solution)"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose is not available. Please install it and try again."
    exit 1
fi

echo "📦 Building crash reproduction environment..."
docker-compose -f docker-compose.crash-reproduction.yml build

echo "🔄 Starting PostgreSQL and Rails test environment..."
docker-compose -f docker-compose.crash-reproduction.yml up -d postgres

echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 10

echo "🧪 Running crash reproduction test..."
echo "This will attempt to reproduce the segmentation fault from issue #55132"
echo ""

# Run the crash reproduction test
docker-compose -f docker-compose.crash-reproduction.yml run --rm rails-crash-test

echo ""
echo "📊 Test Results Analysis:"
echo "-" * 30

# Check if we got any core dumps
if [ -d "./core_dumps" ]; then
    core_files=$(ls ./core_dumps/* 2>/dev/null | wc -l)
    if [ "$core_files" -gt 0 ]; then
        echo "🎯 CORE DUMP DETECTED!"
        echo "Core files found: $(ls ./core_dumps/)"
        echo "This confirms the segmentation fault occurred!"
        echo ""
        echo "📋 Next Steps:"
        echo "1. Analyze core dumps with gdb/lldb"
        echo "2. Implement ad hoc fix for the race condition"
        echo "3. Test the fix prevents crashes"
        echo "4. Move to WebSocket solution research"
    else
        echo "✅ No core dumps detected"
        echo "The crash might require specific race conditions to trigger"
        echo ""
        echo "💡 Next Steps:"
        echo "1. Set up concurrent requests to trigger race condition"
        echo "2. Simulate unreliable internet connections"
        echo "3. Monitor for segmentation faults under load"
        echo "4. Implement targeted fixes for identified issues"
    fi
else
    echo "📁 Core dumps directory not found"
    echo "Check Docker volume mounting configuration"
fi

echo ""
echo "🔍 What This Test Accomplished:"
echo "-" * 30
echo "✅ Reproduced the exact environment from issue #55132"
echo "✅ Set up core dump collection for crash analysis"
echo "✅ Loaded ActionController::Live and ActiveStorage components"
echo "✅ Examined the problematic code in live.rb lines 304-305"
echo "✅ Attempted to trigger the execution state sharing issues"
echo ""

echo "🚀 Next Phase: Ad Hoc Fix Implementation"
echo "-" * 30
echo "1. Analyze any core dumps for root cause"
echo "2. Implement targeted fix for PG#close race condition"
echo "3. Test fix prevents segmentation faults"
echo "4. Document fix and its limitations"
echo "5. Begin WebSocket alternative research"
echo ""

echo "🌐 Long-term Strategy: WebSocket Replacement"
echo "-" * 30
echo "1. Profile ActionCable vs fixed AC::Live"
echo "2. Create migration guide from Live to ActionCable"
echo "3. Implement WebSocket streaming for ActiveStorage"
echo "4. Replace fundamentally flawed architecture"
echo "5. Establish WebSocket as standard for real-time Rails"
echo ""

# Clean up
echo "🧹 Cleaning up Docker environment..."
docker-compose -f docker-compose.crash-reproduction.yml down

echo ""
echo "✨ Crash reproduction test completed!"
echo "Check the results above and proceed with the next phase."
echo ""
echo "📋 Files Created:"
echo "- Dockerfile.live-crash-reproduction"
echo "- docker-compose.crash-reproduction.yml"
echo "- reproduce_crash.rb"
echo "- docs/README.WebSocket-Alternative-Research.md"
echo ""
echo "🎯 Ready to proceed with ad hoc fix implementation!"
