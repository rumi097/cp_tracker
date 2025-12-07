#!/bin/bash

# CP Tracker - Get Local IP for Physical Device Testing
# This script helps you find your computer's IP address for backend connection

echo "🔍 Finding your local IP address for CP Tracker backend..."
echo ""

# For macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📱 For physical device testing, use this IP in lib/main.dart:"
    echo ""
    IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
    if [ -n "$IP" ]; then
        echo "   const backendUrl = 'http://$IP:3000';"
        echo ""
        echo "✅ Your IP: $IP"
        echo ""
        echo "🔧 Update lib/main.dart line 26 with this URL"
        echo "📡 Make sure both devices are on the same WiFi network"
    else
        echo "❌ Could not find IP address. Check your network connection."
    fi
fi

# For Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "📱 For physical device testing, use this IP in lib/main.dart:"
    echo ""
    IP=$(hostname -I | awk '{print $1}')
    if [ -n "$IP" ]; then
        echo "   const backendUrl = 'http://$IP:3000';"
        echo ""
        echo "✅ Your IP: $IP"
        echo ""
        echo "🔧 Update lib/main.dart line 26 with this URL"
        echo "📡 Make sure both devices are on the same WiFi network"
    else
        echo "❌ Could not find IP address. Check your network connection."
    fi
fi

echo ""
echo "📝 Current backend URL in main.dart:"
grep "backendUrl" /Users/aliazgorrumi/Development/cp_tracker/lib/main.dart 2>/dev/null || echo "   (Could not read file)"
echo ""
