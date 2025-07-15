# GitHub Actions CI/CD Implementation

This directory contains the GitHub Actions workflow configuration for automated testing of the web framework comparison project.

## Overview

The CI/CD workflow (`ci.yml`) automatically:

1. **Starts Docker Compose services** - Brings up all web framework services and reverse proxies
2. **Tests endpoint connectivity** - Verifies that all services are responding correctly
3. **Validates proxy configurations** - Tests Nginx and Caddy proxy setups
4. **Provides comprehensive logging** - Offers detailed debugging information on failures

## Workflow Features

### Architecture Compatibility
- Uses `compose.ci.yml` override file to ensure x86_64 compatibility in GitHub Actions
- Handles platform differences between development (ARM64) and CI (AMD64) environments

### Incremental Service Startup
1. **Core Services First**: FastAPI and Flask services
2. **Node.js Services**: NestJS and Express services  
3. **Proxy Services**: Nginx and Caddy reverse proxies

### Robust Testing
- **Retry Logic**: Each endpoint test retries up to 10 times with backoff
- **Health Checks**: Tests both main endpoints and health check endpoints
- **SSL Certificate Generation**: Automatically creates self-signed certificates for HTTPS testing
- **Comprehensive Logging**: Detailed logs on failure for debugging

### Resource Management
- **Disk Space Cleanup**: Frees up unnecessary files before build
- **Service Cleanup**: Properly stops and removes containers after testing
- **Timeout Protection**: 30-minute timeout to prevent hung builds

## Endpoints Tested

### Direct Service Endpoints (HTTP)
- FastAPI: `http://localhost:8080/fastapi-tcp/v1/user`
- Flask: `http://localhost:8081/flask-tcp/v1/user`
- NestJS: `http://localhost:8082/nestjs-tcp/v1/user`
- Express: `http://localhost:8083/express-tcp/v1/user`

### Proxy Endpoints (HTTPS)
- Nginx → FastAPI: `https://localhost:8443/fastapi-tcp/v1/user`
- Nginx → FastAPI (UDS): `https://localhost:8443/fastapi-uds/v1/user`
- Caddy → FastAPI: `https://localhost:443/fastapi-tcp/v1/user`

### Health Check Endpoints (Optional)
- FastAPI: `http://localhost:8080/fastapi-tcp/v1/healthchek`
- NestJS: `http://localhost:8082/nestjs-tcp/v1/healthcheck`
- Express: `http://localhost:8083/express-tcp/v1/healthcheck`

## Triggering the Workflow

The workflow runs automatically on:
- **Push** to `main` or `develop` branches
- **Pull Request** to `main` or `develop` branches
- **Manual trigger** via GitHub Actions UI

## Files

- `ci.yml` - Main GitHub Actions workflow file
- `../compose.ci.yml` - Platform compatibility override for CI environment

## Local Testing

To test the CI setup locally:

```bash
# Generate SSL certificates
mkdir -p ssl
openssl req -x509 -newkey rsa:4096 -keyout ssl/localhost-key.pem -out ssl/localhost.pem -days 365 -nodes -subj "/CN=localhost"
cp ssl/localhost*.pem caddy/

# Create reports directory
mkdir -p reports

# Start services with CI overrides
docker compose -f compose.yaml -f compose.ci.yml up -d

# Test endpoints (wait for services to start)
sleep 60
curl http://localhost:8080/fastapi-tcp/v1/user
curl http://localhost:8081/flask-tcp/v1/user

# Cleanup
docker compose -f compose.yaml -f compose.ci.yml down -v
```

## Troubleshooting

### Common Issues

1. **Build Failures**: Check the "Show service logs on failure" step for detailed error messages
2. **Connectivity Issues**: Verify that services have enough time to start (check retry loops)
3. **SSL Certificate Issues**: Ensure certificates are properly generated and copied to the caddy directory
4. **Platform Issues**: Verify that `compose.ci.yml` overrides are applied correctly

### Debugging

The workflow provides comprehensive debugging information:
- Container status and logs
- Resource usage information
- Step-by-step endpoint testing results
- Full service logs on failure

## Expected Results

A successful workflow run indicates:
- ✅ All services start successfully
- ✅ All direct endpoints respond with `{"status": "success"}`
- ✅ Proxy endpoints correctly forward requests
- ✅ SSL/TLS termination works properly
- ✅ Health check endpoints are accessible (when available)