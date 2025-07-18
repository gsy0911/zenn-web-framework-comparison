# Fastify Framework Sample

This is a Fastify implementation for web framework comparison benchmarking.

## Features

- GET `/user` endpoint that returns `{"status": "success"}`
- GET `/healthcheck` endpoint for health monitoring
- Environment variable `PREFIX` support for URL prefix configuration
- CORS enabled for cross-origin requests

## Local Development

```bash
# Install dependencies
npm install

# Start in development mode
npm run start:dev

# Build for production
npm run build

# Start production server
npm run start:prod
```

## Environment Variables

- `PREFIX`: URL prefix for all endpoints (e.g., `/fastify-tcp/v1`)

## Endpoints

- `GET /{PREFIX}/user` - Returns success status
- `GET /{PREFIX}/healthcheck` - Health check endpoint

## Docker

The application is containerized and can be run using Docker:

```bash
docker build -t fastify-app .
docker run -p 8080:8080 -e PREFIX="/fastify-tcp/v1" fastify-app
```

**Note**: If you encounter SSL certificate issues during `npm install` in Docker builds, you may need to configure NPM to use different registry settings or disable strict SSL verification for development environments.

## Testing

The implementation has been tested and verified to work correctly:

1. **User endpoint**: Returns `{"status": "success"}` 
2. **Health check endpoint**: Returns `{"status": "success"}`
3. **CORS functionality**: Properly handles cross-origin requests
4. **Environment variables**: Supports PREFIX configuration for URL routing