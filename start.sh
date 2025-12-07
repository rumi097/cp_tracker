#!/bin/bash

# CP Tracker - Complete Setup & Start Script
# This script provides a guided setup for first-time users

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    CP Tracker - Quick Setup                        ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Check prerequisites
echo "📋 Step 1: Checking prerequisites..."
echo ""

# Check Flutter
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo "✅ Flutter: $FLUTTER_VERSION"
else
    echo "❌ Flutter not found. Please install Flutter SDK first."
    exit 1
fi

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js: $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js 16+ first."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 2: Device selection
echo "📱 Step 2: Select your testing device"
echo ""
echo "   1) Emulator/Simulator (localhost)"
echo "   2) Physical Device (requires IP configuration)"
echo ""
read -p "Enter choice (1 or 2): " DEVICE_CHOICE
echo ""

if [ "$DEVICE_CHOICE" == "2" ]; then
    echo "🔍 Detecting your local IP address..."
    IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
    
    if [ -n "$IP" ]; then
        echo ""
        echo "✅ Your IP: $IP"
        echo ""
        echo "⚠️  IMPORTANT: Update lib/main.dart line 26:"
        echo "   const backendUrl = 'http://$IP:3000';"
        echo ""
        read -p "Press Enter after updating main.dart, or Ctrl+C to exit and update later..."
        echo ""
    else
        echo "❌ Could not detect IP. Please configure manually."
        echo ""
    fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 3: Install dependencies
echo "📦 Step 3: Installing dependencies..."
echo ""

echo "   → Installing Flutter packages..."
flutter pub get > /dev/null 2>&1
echo "   ✅ Flutter packages installed"

echo "   → Installing backend packages..."
cd backend
npm install > /dev/null 2>&1
cd ..
echo "   ✅ Backend packages installed"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Step 4: Start services
echo "🚀 Step 4: Starting CP Tracker..."
echo ""

echo "   → Starting backend server on port 3000..."
cd backend
node server.js &
BACKEND_PID=$!
cd ..

# Wait for backend to start
sleep 2

# Check if backend is running
if curl -s http://localhost:3000/health > /dev/null 2>&1; then
    echo "   ✅ Backend server started (PID: $BACKEND_PID)"
else
    echo "   ❌ Backend failed to start"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

echo ""
echo "   → Launching Flutter app..."
echo ""
flutter run

# Cleanup on exit
echo ""
echo "🛑 Stopping backend server..."
kill $BACKEND_PID 2>/dev/null
echo "✅ Cleanup complete"
echo ""
echo "Thanks for using CP Tracker! Keep that streak alive! 🔥"
