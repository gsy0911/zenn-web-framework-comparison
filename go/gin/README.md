# Go Gin Framework Sample

This directory contains a sample web application built with Go and the Gin web framework.

## 🚀 Features

- **Go 1.21** with Gin web framework
- **RESTful API** with JSON responses
- **Environment-based configuration** via PREFIX env var
- **Docker containerization** for easy deployment
- **Health check endpoint** for monitoring

## 📋 API Endpoints

The application provides the following endpoints:

### GET /user
Returns a success status.

**Response:**
```json
{
  "status": "success"
}
```

### GET /healthcheck
Health check endpoint for monitoring.

**Response:**
```json
{
  "status": "success"
}
```

## 🏃‍♂️ Running the Application

### Local Development

1. **Prerequisites:**
   - Go 1.21 or later
   - Git

2. **Install dependencies:**
   ```bash
   cd go/gin
   go mod download
   ```

3. **Run the application:**
   ```bash
   cd src
   go run main.go
   ```

   The server will start on port 8080.

4. **Test the endpoints:**
   ```bash
   curl http://localhost:8080/user
   curl http://localhost:8080/healthcheck
   ```

### Docker Deployment

1. **Build the Docker image:**
   ```bash
   cd go/gin
   docker build -t gin-sample .
   ```

2. **Run the container:**
   ```bash
   docker run -p 8080:8080 gin-sample
   ```

3. **With PREFIX environment variable:**
   ```bash
   docker run -p 8080:8080 -e PREFIX="/api/v1" gin-sample
   ```

## 🔧 Configuration

The application can be configured using environment variables:

- `PREFIX`: URL path prefix for all routes (optional)
  - Example: If PREFIX="/api/v1", endpoints become `/api/v1/user` and `/api/v1/healthcheck`

## 📦 Dependencies

- **Gin**: High-performance HTTP web framework
- **Go 1.21**: Latest stable Go version with improved performance

## 🐳 Docker Compose

This application is integrated into the main docker-compose.yaml file as the `gin-tcp` service.

To run with the full framework comparison:

```bash
# From the root directory
docker-compose up gin-tcp
```

The service will be available at `http://localhost:8086`