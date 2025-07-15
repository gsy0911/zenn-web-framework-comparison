# Multi-stage build for Rust
FROM rust:1.75-bullseye AS builder

WORKDIR /opt/app
COPY Cargo.toml ./
COPY src ./src

# Build the application
RUN cargo build --release

# Runtime stage - use the same base image to avoid compatibility issues
FROM rust:1.75-bullseye AS runtime

# Copy the built binary
COPY --from=builder /opt/app/target/release/warp-app /usr/local/bin/warp-app

WORKDIR /opt/app

# Expose port
EXPOSE 8080

# Run the application
CMD ["warp-app"]