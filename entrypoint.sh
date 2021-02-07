#!/bin/sh

python3 generate_config.py --certbot && certbot -n certonly; crond && ./generate_config.py --postfix && postfix start-fg