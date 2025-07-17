#!/bin/bash

# Endpoint connectivity test script
# This script tests all the endpoints that the GitHub Actions workflow tests

set -e

echo "=== Web Framework Endpoint Connectivity Test ==="
echo "This script tests the same endpoints as the GitHub Actions CI workflow"
echo

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to test an endpoint
test_endpoint() {
    local url=$1
    local name=$2
    local max_attempts=${3:-5}
    
    echo -n "Testing $name... "
    
    for i in $(seq 1 $max_attempts); do
        if curl -f -s "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Success${NC}"
            return 0
        else
            if [ $i -eq $max_attempts ]; then
                echo -e "${RED}✗ Failed after $max_attempts attempts${NC}"
                return 1
            else
                sleep 5
            fi
        fi
    done
}

# Function to test with response content
test_endpoint_with_response() {
    local url=$1
    local name=$2
    
    echo -n "Testing $name... "
    
    response=$(curl -f -s "$url" 2>/dev/null)
    if [ $? -eq 0 ] && echo "$response" | grep -q '"status":"success"'; then
        echo -e "${GREEN}✓ Success${NC} - Response: $response"
        return 0
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
}

# Check if services are running
echo "=== Checking if Docker Compose services are running ==="
if ! docker compose ps | grep -q "Up"; then
    echo -e "${YELLOW}Warning: No running Docker Compose services detected.${NC}"
    echo "To start services, run: docker compose up -d"
    echo "For CI environment, run: docker compose -f compose.yaml -f compose.ci.yml up -d"
    echo
fi

# Test direct service endpoints
echo "=== Testing Direct Service Endpoints (HTTP) ==="
success_count=0
total_tests=6

if test_endpoint_with_response "http://localhost:8080/fastapi-tcp/v1/user" "FastAPI TCP"; then
    ((success_count++))
fi

if test_endpoint_with_response "http://localhost:8081/flask-tcp/v1/user" "Flask TCP"; then
    ((success_count++))
fi

if test_endpoint_with_response "http://localhost:8082/nestjs-tcp/v1/user" "NestJS TCP"; then
    ((success_count++))
fi

if test_endpoint_with_response "http://localhost:8083/express-tcp/v1/user" "Express TCP"; then
    ((success_count++))
fi

if test_endpoint_with_response "http://localhost:8086/gin-tcp/v1/user" "Gin TCP"; then
    ((success_count++))
fi

if test_endpoint_with_response "http://localhost:8087/fiber-tcp/v1/user" "Fiber TCP"; then
    ((success_count++))
fi

echo
echo "Direct endpoints: $success_count/$total_tests successful"

# Test proxy endpoints
echo
echo "=== Testing Proxy Endpoints (HTTPS) ==="
proxy_success=0
proxy_total=3

if test_endpoint "https://localhost:8443/fastapi-tcp/v1/user" "Nginx → FastAPI TCP" 3; then
    ((proxy_success++))
fi

if test_endpoint "https://localhost:8443/fastapi-uds/v1/user" "Nginx → FastAPI UDS" 3; then
    ((proxy_success++))
fi

if test_endpoint "https://localhost:443/fastapi-tcp/v1/user" "Caddy → FastAPI TCP" 3; then
    ((proxy_success++))
fi

echo
echo "Proxy endpoints: $proxy_success/$proxy_total successful"

# Test health check endpoints
echo
echo "=== Testing Health Check Endpoints (Optional) ==="
health_success=0
health_total=3

if test_endpoint "http://localhost:8080/fastapi-tcp/v1/healthchek" "FastAPI Health Check" 1; then
    ((health_success++))
fi

if test_endpoint "http://localhost:8082/nestjs-tcp/v1/healthcheck" "NestJS Health Check" 1; then
    ((health_success++))
fi

if test_endpoint "http://localhost:8083/express-tcp/v1/healthcheck" "Express Health Check" 1; then
    ((health_success++))
fi

echo
echo "Health check endpoints: $health_success/$health_total successful"

# Summary
echo
echo "=== Summary ==="
total_success=$((success_count + proxy_success + health_success))
total_all=$((total_tests + proxy_total + health_total))

if [ $success_count -eq $total_tests ] && [ $proxy_success -eq $proxy_total ]; then
    echo -e "${GREEN}✓ All critical endpoints are working!${NC}"
    echo -e "Direct endpoints: ${GREEN}$success_count/$total_tests${NC}"
    echo -e "Proxy endpoints: ${GREEN}$proxy_success/$proxy_total${NC}"
    echo -e "Health endpoints: $health_success/$health_total (optional)"
    exit 0
elif [ $success_count -eq $total_tests ]; then
    echo -e "${YELLOW}⚠ Direct endpoints working, but some proxy endpoints failed${NC}"
    echo -e "Direct endpoints: ${GREEN}$success_count/$total_tests${NC}"
    echo -e "Proxy endpoints: ${RED}$proxy_success/$proxy_total${NC}"
    echo -e "Health endpoints: $health_success/$health_total (optional)"
    exit 1
else
    echo -e "${RED}✗ Some critical endpoints are not working${NC}"
    echo -e "Direct endpoints: ${RED}$success_count/$total_tests${NC}"
    echo -e "Proxy endpoints: ${RED}$proxy_success/$proxy_total${NC}"
    echo -e "Health endpoints: $health_success/$health_total (optional)"
    exit 1
fi