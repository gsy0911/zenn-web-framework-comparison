# Rust Rocket Framework Sample Application

This directory contains a sample web application built with the Rocket framework for Rust, designed to be part of the web framework comparison project.

## Features

- **GET /user**: Returns a JSON response with `{"status": "success"}`
- **GET /healthcheck**: Returns a JSON response with `{"status": "success"}`
- **Environment Variable Support**: Uses `PREFIX` environment variable for URL routing
- **Docker Support**: Includes Dockerfile for containerization
- **Proxy Integration**: Configured to work with Nginx and Caddy reverse proxies

## Local Development

### Prerequisites

- Rust 1.70+ (uses Rocket 0.5)
- Cargo

### Running Locally

```bash
# Build the application
cargo build --release

# Run with prefix
PREFIX="/rocket-tcp/v1" ./target/release/rocket-app

# Test endpoints
curl http://localhost:8080/rocket-tcp/v1/user
curl http://localhost:8080/rocket-tcp/v1/healthcheck
```

## Docker

```bash
# Build Docker image
docker build -t rocket-app .

# Run container
docker run -p 8080:8080 -e PREFIX="/rocket-tcp/v1" rocket-app
```

## Integration with Framework Comparison

This Rocket application is integrated with the framework comparison project:

- **Port**: 8084 (in Docker Compose)
- **Proxy Support**: Configured in nginx and caddy
- **Load Testing**: Locust scripts available for benchmarking
- **Task Runner**: Integrated with taskfile.yml

### Available Tasks

```bash
# Run bare TCP benchmark
task bare-tcp-rocket

# Run nginx proxy benchmark  
task nginx-tcp-rocket

# Run caddy proxy benchmark
task caddy-tcp-rocket
```

## Architecture

- **Framework**: Rocket 0.5
- **Language**: Rust
- **JSON Serialization**: Serde
- **Async Runtime**: Tokio

## Performance

The Rocket application is designed to be a lightweight, high-performance HTTP server comparable to other frameworks in this benchmark suite.