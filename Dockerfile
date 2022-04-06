FROM debian:bullseye-slim AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jre-headless

FROM base AS compile
WORKDIR /src
RUN apt-get install -y --no-install-recommends openjdk-11-jdk-headless maven
COPY . .
RUN mvn --batch-mode --update-snapshots verify

FROM base AS run
RUN mkdir /app && \
    mkdir /data
WORKDIR /data
COPY --from=compile /src/target/JMusicBot-Snapshot-All.jar /app
CMD ["java", "-Dnogui=true", "-jar", "/app/JMusicBot-Snapshot-All.jar"]

