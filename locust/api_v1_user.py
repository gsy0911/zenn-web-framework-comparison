from locust import HttpUser, task
import os

HOST = os.environ['HOST']
URL = os.environ['URL']

class User(HttpUser):
    host = HOST

    @task
    def access(self):
        _ = self.client.get(
            url=URL,
            verify=False,
            headers={"Keep-Alive": "timeout=5, max=1000"},
            # verify="./ssl/localhost.pem",
            # cert=(
            #     # クライアント証明書
            #     "./ssl/localhost.pem",
            #     # 秘密鍵
            #     "./ssl/localhost-key.pem"
            # )
        )
