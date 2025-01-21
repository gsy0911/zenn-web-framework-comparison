FROM python:3.12-bullseye AS builder

WORKDIR /opt/app
COPY requirements.lock ./
RUN PYTHONDONTWRITEBYTECODE=1 pip install --no-cache-dir -r requirements.lock

# mount
# COPY python/fastapi/src .
WORKDIR /opt/app/src
CMD ["uvicorn", "main:app", "--reload", "--host=0.0.0.0", "--port=8080"]

