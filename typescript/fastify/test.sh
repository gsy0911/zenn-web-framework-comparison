#!/bin/bash

# Simple test script for Fastify implementation
echo "Starting Fastify TypeScript implementation test..."

cd "$(dirname "$0")"

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies"
        exit 1
    fi
fi

# Build the project
echo "🔨 Building the project..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "✅ Build successful"

# Start the server in background
echo "🚀 Starting Fastify server..."
PREFIX="/fastify-tcp/v1" npm run start:prod &
SERVER_PID=$!

# Wait for server to start
sleep 3

# Test endpoints
echo "🧪 Testing endpoints..."

# Test user endpoint
USER_RESPONSE=$(curl -s http://localhost:8080/fastify-tcp/v1/user)
if [[ "$USER_RESPONSE" == '{"status":"success"}' ]]; then
    echo "✅ User endpoint working: $USER_RESPONSE"
else
    echo "❌ User endpoint failed: $USER_RESPONSE"
    kill $SERVER_PID
    exit 1
fi

# Test healthcheck endpoint
HEALTH_RESPONSE=$(curl -s http://localhost:8080/fastify-tcp/v1/healthcheck)
if [[ "$HEALTH_RESPONSE" == '{"status":"success"}' ]]; then
    echo "✅ Health check endpoint working: $HEALTH_RESPONSE"
else
    echo "❌ Health check endpoint failed: $HEALTH_RESPONSE"
    kill $SERVER_PID
    exit 1
fi

# Test CORS
CORS_HEADER=$(curl -s -H "Origin: http://example.com" -I http://localhost:8080/fastify-tcp/v1/user | grep -i "access-control-allow-origin")
if [[ -n "$CORS_HEADER" ]]; then
    echo "✅ CORS working: $CORS_HEADER"
else
    echo "❌ CORS not working"
    kill $SERVER_PID
    exit 1
fi

# Stop the server
kill $SERVER_PID

echo "🎉 All tests passed! Fastify TypeScript implementation is working correctly."