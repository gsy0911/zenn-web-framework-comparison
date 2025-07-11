FROM python:3.12-bullseye AS builder

WORKDIR /opt/app
RUN PYTHONDONTWRITEBYTECODE=1 pip install --no-cache-dir flask==3.1.1 gunicorn==23.0.0

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN useradd -m nginxuser
RUN mkdir -p /opt/app/tmp \
 && chown -R nginxuser:nginxuser /opt/app/tmp \
 && chmod -R 777 /opt/app/tmp

USER nginxuser
WORKDIR /opt/app/src
