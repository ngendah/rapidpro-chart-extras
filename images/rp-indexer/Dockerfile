FROM ubuntu:20.04

ARG RP_INDEXER_VERSION
ENV RP_INDEXER_VERSION=${RP_INDEXER_VERSION}

RUN set -ex \
    && apt-get -y update \
    && apt-get install -y wget \
    && addgroup --system indexer \
    && adduser -u 1001 --system --ingroup indexer indexer

USER indexer
RUN mkdir -p /home/indexer/app
WORKDIR /home/indexer
RUN set -ex; \
    wget -qO indexer.tar.gz "https://github.com/nyaruka/rp-indexer/releases/download/v${RP_INDEXER_VERSION}/rp-indexer_${RP_INDEXER_VERSION}_linux_amd64.tar.gz" \
    && tar -C ./app -xf indexer.tar.gz \
    && rm -rf indexer indexer.tar.gz

WORKDIR app
COPY startup.sh .
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./startup.sh"]
