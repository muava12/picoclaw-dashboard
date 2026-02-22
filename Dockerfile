FROM alpine:3.19
WORKDIR /app
COPY picoclaw-dashboard /app/
EXPOSE 8080
ENTRYPOINT ["/app/picoclaw-dashboard"]
