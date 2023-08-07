FROM ubuntu:20.04 AS base

ARG RP_ARCHIVER_VERSION
ENV RP_ARCHIVER_VERSION=${RP_ARCHIVER_VERSION:-7.4.0}

RUN set -ex \
    && addgroup --system archiver \
    && adduser --system --ingroup archiver archiver

FROM base AS build
RUN set -ex \
    && apt-get -y update \
    && apt-get install -y wget \
    && wget -qO archiver.tar.gz "https://github.com/nyaruka/rp-archiver/releases/download/v${RP_ARCHIVER_VERSION}/rp-archiver_${RP_ARCHIVER_VERSION}_linux_amd64.tar.gz" \
    && mkdir app \
    && tar -C app -xf archiver.tar.gz

FROM base
COPY --from=build /app/ /app/
COPY startup.sh /app/
WORKDIR /app/
USER archiver
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./startup.sh"]
