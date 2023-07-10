FROM nginx:bookworm

RUN set -ex && apt-get update && apt-get install -y apache2-utils
COPY ./nginx.conf /etc/nginx/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 80
STOPSIGNAL SIGQUIT
