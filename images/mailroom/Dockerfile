FROM ubuntu:20.04 AS base

ARG MAILROOM_VERSION
ENV MAILROOM_VERSION=${MAILROOM_VERSION:-7.4.1}

RUN set -ex \
    && addgroup --system mailroom \
    && adduser --system --ingroup mailroom mailroom

FROM base AS build
RUN set -ex \
    && apt-get -y update \
    && apt-get install -y wget \
    && wget -qO mailroom.tar.gz "https://github.com/rapidpro/mailroom/releases/download/v${MAILROOM_VERSION}/mailroom_${MAILROOM_VERSION}_linux_amd64.tar.gz" \
    && mkdir app \
    && tar -C app -xf mailroom.tar.gz

FROM base
COPY --from=build /app/ /app/
COPY startup.sh ./app/
WORKDIR /app/
USER mailroom
EXPOSE 8090
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./startup.sh"]
