FROM caddy:latest

COPY localhost.pem .
COPY localhost-key.pem .
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--watch"]
