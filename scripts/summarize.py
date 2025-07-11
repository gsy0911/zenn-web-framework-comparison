import pandas as pd
from pydantic import BaseModel, Field


class LocustStats(BaseModel):
    locustfile: str = Field(alias="locustfile")
    type: str | float = Field(alias="Type")
    name: str = Field(alias="Name")
    request_count: int = Field(alias="Request Count")
    failure_count: int = Field(alias="Failure Count")
    median_response_time: float = Field(alias="Median Response Time")
    average_response_time: float = Field(alias="Average Response Time")
    min_response_time: float = Field(alias="Min Response Time")
    max_response_time: float = Field(alias="Max Response Time")
    average_content_size: float = Field(alias="Average Content Size")
    requests_per_s: float = Field(alias="Requests/s")
    failures_per_s: float = Field(alias="Failures/s")
    p50: float = Field(alias="50%")
    p66: float = Field(alias="66%")
    p75: float = Field(alias="75%")
    p80: float = Field(alias="80%")
    p90: float = Field(alias="90%")
    p95: float = Field(alias="95%")
    p98: float = Field(alias="98%")
    p99: float = Field(alias="99%")
    p999: float = Field(alias="99.9%")
    p9999: float = Field(alias="99.99%")
    p100: float = Field(alias="100%")


class XYChart(BaseModel):
    locust_stats: list[LocustStats]

    def dump(self) -> str:
        x_axis = []
        bar = []
        for stats in self.locust_stats:
            x_axis.append(stats.locustfile)
            bar.append(str(int(stats.requests_per_s)))

        return f"""
```mermaid
xychart-beta horizontal
    title "Web Framework Benchmark"
    x-axis [{", ".join(x_axis)}]
    y-axis "Requests per sec (higher is better)" 1000 --> 5000
    bar [{", ".join(bar)}]
```
"""


def main():
    base_path = "./reports/{locustfile}_stats.csv"
    locustfiles = [
        "nginx_uds_fastapi.py",
        "nginx_tcp_fastapi.py",
        "caddy_tcp_fastapi.py",
        "bare_tcp_fastapi.py",
        "bare_tcp_flask.py",
    ]
    paths = [base_path.format(locustfile=l) for l in locustfiles]
    dfs = []
    for p in paths:
        df = pd.read_csv(p)
        df["locustfile"] = p.rsplit("/", 1)[1].split(".py", 1)[0]
        dfs.append(df)

    df = pd.concat(dfs)

    stats = []

    for _, row in df.sort_values(by=["Requests/s"], ascending=False).iterrows():
        l = LocustStats(**dict(row))
        if l.type == "GET":
            stats.append(l)
    print(XYChart(locust_stats=stats).dump())


if __name__ == "__main__":
    main()
