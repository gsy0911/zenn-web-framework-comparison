# Express Application for Web Framework Comparison

This is a TypeScript Express application designed for performance benchmarking against other web frameworks.

## Features

- TypeScript implementation with Express.js
- RESTful API endpoints compatible with the benchmark suite
- Environment variable support for URL prefixes
- CORS enabled for cross-origin requests
- Docker containerization support

## Endpoints

- `GET /{prefix}/user` - Main benchmark endpoint, returns `{"status": "success"}`
- `GET /{prefix}/healthcheck` - Health check endpoint

## Environment Variables

- `PREFIX` - URL prefix for all endpoints (optional)

## Development

```bash
# Install dependencies
npm install

# Run in development mode
npm run start:dev

# Build for production
npm run build

# Run production build
npm run start:prod
```

## Docker

```bash
# Build image
docker build -t comparison-express .

# Run container
docker run -p 8080:8080 -e PREFIX="/express-tcp/v1" comparison-express
```