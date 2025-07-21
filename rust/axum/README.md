# Rust Axum Framework Sample Application

This directory contains a sample web application built with the Axum framework for Rust, designed to be part of the web framework comparison project.

## Features

- **GET /user**: Returns a JSON response with `{"status": "success"}`
- **GET /healthcheck**: Returns a JSON response with `{"status": "success"}`
- **Environment Variable Support**: Uses `PREFIX` environment variable for URL routing
- **Docker Support**: Includes Dockerfile for containerization
- **Proxy Integration**: Configured to work with Nginx and Caddy reverse proxies

## Local Development

### Prerequisites

- Rust 1.70+ (uses Axum 0.7)
- Cargo

### Running Locally

```bash
# Build the application
cargo build --release

# Run with prefix
PREFIX="/axum-tcp/v1" ./target/release/axum-app

# Test endpoints
curl http://localhost:8080/axum-tcp/v1/user
curl http://localhost:8080/axum-tcp/v1/healthcheck
```

## Docker

```bash
# Build Docker image
docker build -t axum-app .

# Run container
docker run -p 8080:8080 -e PREFIX="/axum-tcp/v1" axum-app
```

## Integration with Framework Comparison

This Axum application is integrated with the framework comparison project:

- **Port**: 8086 (in Docker Compose)
- **Proxy Support**: Configured in nginx and caddy
- **Load Testing**: Locust scripts available for benchmarking
- **Task Runner**: Integrated with taskfile.yml

### Available Tasks

```bash
# Run bare TCP benchmark
task bare-tcp-axum

# Run nginx proxy benchmark  
task nginx-tcp-axum

# Run caddy proxy benchmark
task caddy-tcp-axum
```

## Architecture

- **Framework**: Axum 0.7
- **Language**: Rust
- **JSON Serialization**: Serde
- **Async Runtime**: Tokio

## Performance

The Axum application is designed to be a lightweight, high-performance HTTP server comparable to other frameworks in this benchmark suite. Axum is built on top of hyper and Tower, providing excellent ergonomics while maintaining high performance.