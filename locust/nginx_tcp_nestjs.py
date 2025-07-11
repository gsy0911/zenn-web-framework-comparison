from locust import HttpUser, task


class User(HttpUser):
    host = "https://localhost:8443"

    @task
    def access(self):
        _ = self.client.get(
            url="/nestjs-tcp/v1/user",
            verify=False,
            headers={"Keep-Alive": "timeout=5, max=1000"},
        )