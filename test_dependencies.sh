#!/bin/bash

echo "🧪 Testing VMAF Analyzer Dependencies (Phase 1.2)..."

APP_PATH=$(find /Users/matthewcelia/Library/Developer/Xcode/DerivedData -name "VMAFAnalyzer.app" -type d 2>/dev/null | grep -v Index.noindex | head -1)

if [ -n "$APP_PATH" ]; then
    echo "✅ App binary found at: $APP_PATH"
    echo "📱 Launching app for dependency verification..."
    
    # Launch app in background
    "$APP_PATH/Contents/MacOS/VMAFAnalyzer" &
    APP_PID=$!
    
    # Wait for dependency verification to complete
    sleep 8
    
    # Kill the app
    kill $APP_PID 2>/dev/null
    
    echo "🔍 Checking Console logs for dependency verification..."
    echo "Filter: 'com.lightsailvr.vmafanalyzer' category 'Process' and 'VMAFAnalysis'"
    
    # Show recent logs related to dependency verification
    log show --predicate 'subsystem == "com.lightsailvr.vmafanalyzer" AND (category == "Process" OR category == "VMAFAnalysis")' --info --debug --last 2m 2>/dev/null | head -20 || echo "Use Console.app to view detailed logs"
    
else
    echo "❌ App binary not found"
    exit 1
fi

echo ""
echo "✅ Phase 1.2 Test Checkpoint - Dependencies Integration"
echo "📊 Expected results:"
echo "   - VMAF binary located (either compiled or system)"
echo "   - FFmpeg binary located (system)"
echo "   - Dependency verification successful"
echo "   - ProcessExecutor and VMAFAnalyzer classes initialized"