# Use the official Go image
FROM golang:1.21-bullseye

WORKDIR /opt/app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Set environment variables to handle any SSL issues
ENV GOPROXY=direct
ENV GOSUMDB=off

# Download dependencies
RUN go mod download

# Copy source code
COPY src/ ./src/

# Build the application
RUN go build -o main ./src

# Create a non-root user
RUN useradd -m -u 1001 appuser

# Change ownership to appuser
RUN chown appuser:appuser main

USER appuser

EXPOSE 8080

CMD ["./main"]