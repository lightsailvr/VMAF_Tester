#!/bin/bash

echo "🧪 Testing VMAF Analyzer App Launch..."
echo "App location: $(find /Users/matthewcelia/Library/Developer/Xcode/DerivedData -name "VMAFAnalyzer.app" -type d 2>/dev/null | head -1)"

APP_PATH=$(find /Users/matthewcelia/Library/Developer/Xcode/DerivedData -name "VMAFAnalyzer.app" -type d 2>/dev/null | head -1)

if [ -n "$APP_PATH" ]; then
    echo "✅ App binary found at: $APP_PATH"
    echo "📱 Launching app for 3 seconds to test logging..."
    
    # Launch app in background
    "$APP_PATH/Contents/MacOS/VMAFAnalyzer" &
    APP_PID=$!
    
    # Wait a bit for app to initialize
    sleep 3
    
    # Kill the app
    kill $APP_PID 2>/dev/null
    
    echo "🔍 Checking Console logs for our app..."
    echo "Use Console.app and filter for 'com.lightsailvr.vmafanalyzer' to see detailed logs"
    
    # Try to show recent logs (if available)
    log show --predicate 'subsystem == "com.lightsailvr.vmafanalyzer"' --info --debug --last 1m 2>/dev/null | head -10 || echo "Use Console.app to view detailed logs"
    
else
    echo "❌ App binary not found"
    exit 1
fi

echo "✅ Phase 1.1 Test Checkpoint Complete!"