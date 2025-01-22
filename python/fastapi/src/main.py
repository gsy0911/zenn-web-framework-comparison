from logging import INFO, getLogger
from fastapi import APIRouter, FastAPI


app = FastAPI()
api_router = APIRouter()

logger = getLogger()
logger.setLevel(INFO)

__all__ = ["app"]


@api_router.get("/user")
def get_user():
    return {"status": "success"}


app.include_router(router=api_router, prefix="/fastapi/v1")

