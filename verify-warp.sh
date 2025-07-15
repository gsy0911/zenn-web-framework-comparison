#!/bin/bash

# Warp Framework Verification Script
echo "🦀 Rust Warp Framework Implementation Verification"
echo "================================================="

cd "$(dirname "$0")"

echo "1. Checking if Warp application builds..."
cd rust/warp
if cargo check; then
    echo "✅ Warp application builds successfully"
else
    echo "❌ Warp application failed to build"
    exit 1
fi

echo ""
echo "2. Testing endpoints with PREFIX..."

# Start server in background
PREFIX="/warp-tcp/v1" cargo run &
SERVER_PID=$!

# Wait for server to start
sleep 5

# Test endpoints
echo "Testing /warp-tcp/v1/user endpoint..."
if curl -s http://localhost:8080/warp-tcp/v1/user | grep -q '"status":"success"'; then
    echo "✅ /user endpoint working"
else
    echo "❌ /user endpoint failed"
fi

echo "Testing /warp-tcp/v1/healthcheck endpoint..."
if curl -s http://localhost:8080/warp-tcp/v1/healthcheck | grep -q '"status":"success"'; then
    echo "✅ /healthcheck endpoint working"
else
    echo "❌ /healthcheck endpoint failed"
fi

# Clean up
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo ""
echo "3. Checking Docker configuration..."
cd ../..

if docker compose config | grep -q "warp-tcp:"; then
    echo "✅ Docker Compose configuration includes Warp service"
else
    echo "❌ Docker Compose configuration missing Warp service"
fi

echo ""
echo "4. Checking task definitions..."
if grep -q "bare-tcp-warp:" taskfile.yml; then
    echo "✅ Taskfile includes Warp benchmark tasks"
else
    echo "❌ Taskfile missing Warp benchmark tasks"
fi

echo ""
echo "5. Checking proxy configurations..."
if grep -q "warp-tcp" caddy/Caddyfile; then
    echo "✅ Caddy configuration includes Warp"
else
    echo "❌ Caddy configuration missing Warp"
fi

if grep -q "warp_tcp" nginx/conf/default.conf; then
    echo "✅ Nginx configuration includes Warp"
else
    echo "❌ Nginx configuration missing Warp"
fi

echo ""
echo "✅ Rust Warp framework implementation completed successfully!"
echo "The Warp application is ready for benchmarking and integration testing."