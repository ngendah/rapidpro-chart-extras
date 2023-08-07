FROM ubuntu:20.04 AS base

ARG COURIER_VERSION
ENV COURIER_VERSION=${COURIER_VERSION:-7.4.0}

RUN set -ex \
    && addgroup --system courier \
    && adduser --system --ingroup courier courier

FROM base AS build
RUN set -ex \
    && apt-get update \
    && apt-get install -y wget \
    && wget -qO courier.tar.gz "https://github.com/nyaruka/courier/releases/download/v${COURIER_VERSION}/courier_${COURIER_VERSION}_linux_amd64.tar.gz" \
    && mkdir app \
    && tar -C app -xf courier.tar.gz

FROM base
COPY --from=build /app/ /app/
COPY startup.sh /app/
WORKDIR /app/
USER courier
EXPOSE 8080
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./startup.sh"]
