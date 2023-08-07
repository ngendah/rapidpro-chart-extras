FROM ubuntu:20.04 AS base

ARG RP_INDEXER_VERSION
ENV RP_INDEXER_VERSION=${RP_INDEXER_VERSION:-7.4.0}

RUN set -ex \
    && addgroup --system indexer \
    && adduser --system --ingroup indexer indexer

FROM base AS build
RUN set -ex \
    && apt-get -y update \
    && apt-get install -y wget \
    && wget -qO indexer.tar.gz "https://github.com/nyaruka/rp-indexer/releases/download/v${RP_INDEXER_VERSION}/rp-indexer_${RP_INDEXER_VERSION}_linux_amd64.tar.gz" \
    && mkdir app \
    && tar -C app -xf indexer.tar.gz

FROM base
COPY --from=build /app/ /app/
COPY startup.sh /app/
WORKDIR /app/
USER indexer
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./startup.sh"]
