FROM python:3.12-bullseye AS builder

WORKDIR /opt/app

RUN pip install uv
COPY pyproject.toml .
RUN uv pip compile pyproject.toml -o requirements.txt && \
    pip install -r requirements.txt

WORKDIR /opt/app/src
CMD ["uvicorn", "main:app", "--reload", "--host=0.0.0.0", "--port=8080"]

