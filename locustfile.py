from locust import HttpUser, task


class HelloWorldUser(HttpUser):
    @task
    def hello_world(self):
        _ = self.client.get("/fastapi/v1/user")
