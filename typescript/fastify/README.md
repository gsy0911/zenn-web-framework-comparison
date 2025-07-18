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