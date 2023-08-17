FROM ubuntu:20.04 as base

ARG UREPORT_VERSION
ENV UREPORT_VERSION=${UREPORT_VERSION:-7.4.2}

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
              python3.9 \
              python3-pip \
              python3.9-venv \
              nodejs \
              openssl \
              npm postgresql-client \
    && addgroup --system ureport \
    && adduser --system --ingroup ureport ureport

WORKDIR /ureport

ENV PATH="/ureport/bin:$PATH"
ENV POETRY_CACHE_DIR=/ureport/.cache

RUN set -ex \
    && python3.9 -m venv . \
    && mkdir -p ./app ./.cache \
    && npm install -g coffeescript less \
    && pip3 install --no-cache -U pip setuptools \
    && pip3 install --no-cache poetry



