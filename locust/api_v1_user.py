from locust import HttpUser, task
import os
import urllib3

HOST = os.environ['HOST']
URL = os.environ['URL']

# TODO: 外す
urllib3.disable_warnings()
# http = urllib3.PoolManager(
#     cert_reqs="CERT_REQUIRED",
#     cert_file="/Users/yoshiki/Development/Projects/zenn-web-framework-comparison/ssl/localhost.pem"
# )


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
