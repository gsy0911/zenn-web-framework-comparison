# flask

Flask sample implementation with simple GET endpoint.

## API

### GET /user

Returns a simple JSON response:

```json
{
  "status": "success"
}
```

## Development

Run locally:

```bash
cd python/flask/src
python main.py
```

## Docker

Build and run with Docker:

```bash
docker build -t flask-app .
docker run -p 8080:8080 flask-app
```