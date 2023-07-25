FROM ubuntu:20.04

ARG RP_ARCHIVER_VERSION
ENV RP_ARCHIVER_VERSION=${RP_ARCHIVER_VERSION}

RUN set -ex \
    && apt-get -y update \
    && apt-get install -y wget \
    && addgroup --system archiver \
    && adduser -u 1001 --system --ingroup archiver archiver

USER archiver
RUN mkdir -p /home/archiver/app
WORKDIR /home/archiver
RUN set -ex; \
    wget -qO archiver.tar.gz "https://github.com/nyaruka/rp-archiver/releases/download/v${RP_ARCHIVER_VERSION}/rp-archiver_${RP_ARCHIVER_VERSION}_linux_amd64.tar.gz" \
    && tar -C ./app -xf archiver.tar.gz \
    && rm -rf archiver archiver.tar.gz

WORKDIR app
COPY startup.sh .
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./startup.sh"]
