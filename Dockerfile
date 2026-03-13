FROM dart:3.0 AS builder

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o clinicflowac_server

FROM ubuntu:24.04

WORKDIR /app

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/clinicflowac_server /app/

ENV PORT=8080
EXPOSE 8080

CMD ["/app/clinicflowac_server"]
