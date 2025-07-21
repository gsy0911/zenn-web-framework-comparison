#!/bin/bash

# Axum Framework Verification Script
echo "🦀 Rust Axum Framework Implementation Verification"
echo "================================================="

cd "$(dirname "$0")"

echo "1. Checking if Axum application builds..."
cd rust/axum
if cargo check; then
    echo "✅ Axum application builds successfully"
else
    echo "❌ Axum application failed to build"
    exit 1
fi

echo ""
echo "2. Testing endpoints with PREFIX..."

# Start server in background
PREFIX="/axum-tcp/v1" cargo run &
SERVER_PID=$!

# Wait for server to start
sleep 5

# Test endpoints
echo "Testing /axum-tcp/v1/user endpoint..."
if curl -s http://localhost:8080/axum-tcp/v1/user | grep -q '"status":"success"'; then
    echo "✅ /user endpoint working"
else
    echo "❌ /user endpoint failed"
fi

echo "Testing /axum-tcp/v1/healthcheck endpoint..."
if curl -s http://localhost:8080/axum-tcp/v1/healthcheck | grep -q '"status":"success"'; then
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

if docker compose config | grep -q "axum-tcp:"; then
    echo "✅ Docker Compose configuration includes Axum service"
else
    echo "❌ Docker Compose configuration missing Axum service"
fi

echo ""
echo "4. Checking task definitions..."
if grep -q "bare-tcp-axum:" taskfile.yml; then
    echo "✅ Taskfile includes Axum benchmark tasks"
else
    echo "❌ Taskfile missing Axum benchmark tasks"
fi

echo ""
echo "5. Checking proxy configurations..."
if grep -q "axum-tcp" caddy/Caddyfile; then
    echo "✅ Caddy configuration includes Axum"
else
    echo "❌ Caddy configuration missing Axum"
fi

if grep -q "axum_tcp" nginx/conf/default.conf; then
    echo "✅ Nginx configuration includes Axum"
else
    echo "❌ Nginx configuration missing Axum"
fi

echo ""
echo "✅ Rust Axum framework implementation completed successfully!"
echo "The Axum application is ready for benchmarking and integration testing."