FROM python:3.12-bullseye AS builder

WORKDIR /opt/app
COPY requirements.lock ./
RUN PYTHONDONTWRITEBYTECODE=1 pip install --no-cache-dir -r requirements.lock

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN useradd -m nginxuser
RUN mkdir -p /opt/app/tmp \
 && chown -R nginxuser:nginxuser /opt/app/tmp \
 && chmod -R 777 /opt/app/tmp

USER nginxuser
WORKDIR /opt/app/src

