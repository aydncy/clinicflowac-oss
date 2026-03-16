FROM dart:latest

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

EXPOSE 8083

CMD ["dart", "run", "bin/server.dart"]