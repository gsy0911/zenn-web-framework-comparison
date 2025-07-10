import os
from logging import INFO, getLogger

from flask import Flask, Response, jsonify

PREFIX = os.environ.get("PREFIX", "")

app = Flask(__name__)

logger = getLogger()
logger.setLevel(INFO)

__all__ = ["app"]


@app.route(f"{PREFIX}/user", methods=["GET"])
def get_user() -> Response:
    return jsonify({"status": "success"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
