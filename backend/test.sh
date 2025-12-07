#!/bin/bash

# Test the backend server

echo "🧪 Testing CP Tracker Backend..."
echo ""

# Start server in background
cd "$(dirname "$0")"
node server.js > test.log 2>&1 &
SERVER_PID=$!

echo "Starting server (PID: $SERVER_PID)..."
sleep 3

# Test health endpoint
echo ""
echo "Testing /health endpoint..."
HEALTH=$(curl -s http://localhost:3000/health)
if [ $? -eq 0 ]; then
    echo "✅ Health check passed: $HEALTH"
else
    echo "❌ Health check failed"
fi

# Test contest endpoint
echo ""
echo "Testing /contest/upcoming endpoint..."
CONTESTS=$(curl -s http://localhost:3000/contest/upcoming)
if [ $? -eq 0 ]; then
    echo "✅ Contest API responded"
    echo "Response preview:"
    echo "$CONTESTS" | head -20
else
    echo "❌ Contest API failed"
fi

# Cleanup
echo ""
echo "Stopping server..."
kill $SERVER_PID 2>/dev/null
rm -f test.log

echo "✅ Test complete!"
