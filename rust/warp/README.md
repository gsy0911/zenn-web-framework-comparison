# Rust Warp Framework Sample Application

This directory contains a sample web application built with the Warp framework for Rust, designed to be part of the web framework comparison project.

## Features

- **GET /user**: Returns a JSON response with `{"status": "success"}`
- **GET /healthcheck**: Returns a JSON response with `{"status": "success"}`
- **Environment Variable Support**: Uses `PREFIX` environment variable for URL routing
- **Docker Support**: Includes Dockerfile for containerization
- **Proxy Integration**: Configured to work with Nginx and Caddy reverse proxies

## Local Development

### Prerequisites

- Rust 1.70+ (uses Warp 0.3)
- Cargo

### Running Locally

```bash
# Build the application
cargo build --release

# Run with prefix
PREFIX="/warp-tcp/v1" ./target/release/warp-app

# Test endpoints
curl http://localhost:8080/warp-tcp/v1/user
curl http://localhost:8080/warp-tcp/v1/healthcheck
```

## Docker

```bash
# Build Docker image
docker build -t warp-app .

# Run container
docker run -p 8080:8080 -e PREFIX="/warp-tcp/v1" warp-app
```

## Integration with Framework Comparison

This Warp application is integrated with the framework comparison project:

- **Port**: 8085 (in Docker Compose)
- **Proxy Support**: Configured in nginx and caddy
- **Load Testing**: Locust scripts available for benchmarking
- **Task Runner**: Integrated with taskfile.yml

### Available Tasks

```bash
# Run bare TCP benchmark
task bare-tcp-warp

# Run nginx proxy benchmark  
task nginx-tcp-warp

# Run caddy proxy benchmark
task caddy-tcp-warp
```

## Architecture

- **Framework**: Warp 0.3
- **Language**: Rust
- **JSON Serialization**: Serde
- **Async Runtime**: Tokio

## Performance

The Warp application is designed to be a lightweight, high-performance HTTP server comparable to other frameworks in this benchmark suite. Warp is built on top of hyper and uses a composable filter system for routing.