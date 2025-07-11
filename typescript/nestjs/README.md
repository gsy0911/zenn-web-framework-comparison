# NestJS Framework Sample

This is a NestJS implementation for web framework comparison benchmarking.

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

- `PREFIX`: URL prefix for all endpoints (e.g., `/nestjs-tcp/v1`)

## Endpoints

- `GET /{PREFIX}/user` - Returns success status
- `GET /{PREFIX}/healthcheck` - Health check endpoint

## Docker

The application is containerized and can be run using Docker:

```bash
docker build -t nestjs-app .
docker run -p 8080:8080 -e PREFIX="/nestjs-tcp/v1" nestjs-app
```