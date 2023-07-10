FROM ubuntu:jammy

RUN set -ex && apt-get update && apt-get install -y dnsutils iproute2 net-tools iputils-ping

ENTRYPOINT ["/bin/sh"]
CMD ["-c", "sleep 99999"]
