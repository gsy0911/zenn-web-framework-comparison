# Multi-stage build for Rust
FROM rust:1.82-bullseye AS builder

WORKDIR /opt/app
COPY Cargo.toml ./
COPY src ./src

# Build the application
RUN cargo build --release

# Runtime stage - use a minimal image
FROM debian:bullseye-slim AS runtime

# Install necessary runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -r -s /bin/false app

# Copy the built binary
COPY --from=builder /opt/app/target/release/axum-app /usr/local/bin/axum-app

# Change ownership to the app user
RUN chown app:app /usr/local/bin/axum-app

WORKDIR /opt/app

# Switch to the app user
USER app

# Expose port
EXPOSE 8080

# Run the application
CMD ["axum-app"]