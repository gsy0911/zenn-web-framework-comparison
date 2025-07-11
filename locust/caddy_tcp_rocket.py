from locust import HttpUser, task


class User(HttpUser):
    host = "https://localhost:443"

    @task
    def access(self):
        _ = self.client.get(
            url="/rocket-tcp/v1/user",
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