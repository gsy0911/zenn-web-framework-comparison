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

## Load Testing

The Express application has been successfully tested with Locust:

- **Test Results**: 13,688 requests processed in 10 seconds
- **Performance**: ~1,393 requests per second  
- **Success Rate**: 100% (zero failures)
- **Response Time**: Median 2ms, 95th percentile 3ms

## Integration

This Express implementation is fully integrated into the web framework comparison suite:

- Added to `docker-compose.yaml` as `express-tcp` service
- Load testing scripts in `locust/` directory (bare TCP, nginx TCP, caddy TCP)
- Task definitions in `taskfile.yml` for automated benchmarking
- Results aggregation in `scripts/summarize.py`
- Reverse proxy configurations for Nginx and Caddy