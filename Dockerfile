FROM alpine:3

EXPOSE 25 465
VOLUME /etc/letsencrypt

# Install system dependencies.
RUN apk add --update --no-cache \
    # Postfix itself:
    postfix=3.5.9-r0 postfix-pgsql=3.5.9-r0 \
    # To generate Postfix config files:
    python3=3.8.7 \
    # To generate and renew Postfix TLS certificate:
    certbot=1.12 \
    dcron=4.5

# Install Python dependencies.
RUN python3 -m ensurepip && pip3 install jinja2

# Copy sources.
COPY generate_config.py /src/
COPY scripts/certbot-renew-crontab.sh /etc/periodic/hourly/renew-postfix-tls
COPY scripts/certbot-renew-posthook.sh /etc/letsencrypt/renewal-hooks/post/reload-postfix.sh
COPY templates /src/templates

# Generate config, ask for a TLS certificate to Let's Encrypt, start Postfix and Cron daemon.
WORKDIR /src
CMD ["./docker-entrypoint.sh"]

# Idea taken from https://github.com/Mailu/Mailu/blob/master/core/postfix/Dockerfile
HEALTHCHECK --start-period=350s CMD echo QUIT|nc localhost 25|grep "220 .* ESMTP Postfix"
