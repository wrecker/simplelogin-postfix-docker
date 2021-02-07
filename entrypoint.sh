#!/bin/sh

python3 generate_config.py --certbot && certbot -n certonly; crond && ./generate_config.py --postfix && postfix start-fg

# Idea taken from https://github.com/Mailu/Mailu/blob/master/core/postfix/Dockerfile
HEALTHCHECK --start-period=350s CMD echo QUIT|nc localhost 25|grep "220 .* ESMTP Postfix"