FROM ubuntu:20.04 as base

ARG RAPIDPRO_VERSION
ENV RAPIDPRO_VERSION=${RAPIDPRO_VERSION:-7.4.2}

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
              python3.9 \
              python3-pip \
              python3.9-venv \
              nodejs \
              openssl \
              npm gdal-bin postgresql-client \
    && addgroup --system rapidpro \
    && adduser --system --ingroup rapidpro rapidpro

WORKDIR /rapidpro

ENV PATH="/rapidpro/bin:$PATH"
ENV POETRY_CACHE_DIR=/rapidpro/.cache

RUN set -ex \
    && python3.9 -m venv . \
    && mkdir -p ./app ./.cache \
    && npm install -g coffeescript less \
    && pip3 install --no-cache -U pip setuptools \
    && pip3 install --no-cache poetry


FROM base AS build
RUN set -ex \
    && apt-get update \
    && apt-get install -y \
            wget \
            build-essential \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype-dev \
            libxslt-dev \
            libxml2-dev \
            zlib1g-dev \
            libffi-dev \
            libpcre2-dev \
            libreadline-dev \
            libncurses-dev \
            libgdal-dev \
            libgeos-dev \
            libxml2 \
            libpcre3 \
            libzmq3-dev

WORKDIR app

RUN set -ex \
    && export RAPIDPRO_VERSION="v${RAPIDPRO_VERSION:-7.4.2}" \
    && export RAPIDPRO_REPO_URL="https://github.com/rapidpro/rapidpro/archive/$RAPIDPRO_VERSION.tar.gz" \
    && echo "Downloading RapidPro $RAPIDPRO_VERSION from $RAPIDPRO_REPO_URL" \
    && wget -q -O rapidpro.tar.gz $RAPIDPRO_REPO_URL \
    && mkdir .npm \
    && tar -C ./ -xf rapidpro.tar.gz --strip-components=1 \
    && rm rapidpro.tar.gz \
    && export CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN set -ex \
    && npm install

RUN set -ex \
    && poetry remove codecov -G dev --lock \
    && poetry add redisbeat --lock \
    && poetry install --without dev --sync


FROM base
COPY --from=build /rapidpro/.cache/ /rapidpro/.cache/
COPY --from=build /rapidpro/app/ /rapidpro/app/
COPY stack/*.py /rapidpro/app/temba/
COPY scripts/*.sh /rapidpro/app/
RUN chmod g=rwx,o=rwx ./app # TODO fix
USER rapidpro
WORKDIR app
EXPOSE 8000
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./server.sh"]

