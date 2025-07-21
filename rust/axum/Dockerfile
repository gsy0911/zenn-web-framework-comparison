# Multi-stage build for Rust
FROM rust:1.82-bullseye AS builder

WORKDIR /opt/app
COPY Cargo.toml ./
COPY src ./src

# Build the application
RUN cargo build --release

# Runtime stage - use the same base image to avoid compatibility issues
FROM rust:1.82-bullseye AS runtime

# Copy the built binary
COPY --from=builder /opt/app/target/release/axum-app /usr/local/bin/axum-app

WORKDIR /opt/app

# Expose port
EXPOSE 8080

# Run the application
CMD ["axum-app"]