from locust import HttpUser, task


class User(HttpUser):
    host = "http://localhost:8080"

    @task
    def access(self):
        _ = self.client.get(
            url="/express-tcp/v1/user",
            verify=False,
            headers={"Keep-Alive": "timeout=5, max=1000"},
        )