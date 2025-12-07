#!/bin/bash

# CP Tracker - Complete Setup & Run Script

echo "🚀 CP Tracker - Setting up complete environment..."
echo ""

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Navigate to backend
cd "$SCRIPT_DIR/backend"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing backend dependencies..."
    npm install
else
    echo "✅ Backend dependencies already installed"
fi

# Start backend in background
echo "🔧 Starting backend server..."
node server.js > backend.log 2>&1 &
BACKEND_PID=$!

echo "✅ Backend running on http://localhost:3000 (PID: $BACKEND_PID)"
echo "   Logs: $SCRIPT_DIR/backend/backend.log"
echo ""

# Wait for backend to start
sleep 3

# Test backend
echo "🧪 Testing backend..."
if curl -s http://localhost:3000/health > /dev/null; then
    echo "✅ Backend is responding!"
else
    echo "⚠️  Backend may not be ready yet. Check backend/backend.log if issues persist."
fi

echo ""

# Navigate to Flutter app root
cd "$SCRIPT_DIR"

echo "📱 Getting Flutter dependencies..."
/Users/aliazgorrumi/develop/flutter/bin/flutter pub get

echo ""
echo "🎯 Starting Flutter app..."
echo ""
echo "📍 Backend API: http://localhost:3000/contest/upcoming"
echo "🧪 Test backend: curl http://localhost:3000/contest/upcoming"
echo ""
echo "⚠️  Press Ctrl+C to stop (this will also stop the backend)"
echo ""

# Trap to ensure backend is killed on script exit
trap "echo ''; echo '🛑 Stopping backend server...'; kill $BACKEND_PID 2>/dev/null; echo '✅ All stopped. Goodbye!'; exit" EXIT INT TERM

# Run Flutter app
/Users/aliazgorrumi/develop/flutter/bin/flutter run

# The trap will handle cleanup automatically
