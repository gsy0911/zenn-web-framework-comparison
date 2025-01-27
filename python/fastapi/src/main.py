import os
from logging import INFO, getLogger

from fastapi import APIRouter, FastAPI

PREFIX = os.environ["PREFIX"]

app = FastAPI()
api_router = APIRouter()

logger = getLogger()
logger.setLevel(INFO)

__all__ = ["app"]


@api_router.get("/user")
def get_user():
    return {"status": "success"}


@api_router.get("/healthchek")
def healthchek():
    return {"status": "success"}


app.include_router(router=api_router, prefix=PREFIX)
