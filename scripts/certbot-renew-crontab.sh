#!/usr/bin/env sh
CERTIFICATE = /etc/letsencrypt/live/$POSTFIX_FQDN/fullchain.pem
PRIVATE_KEY = /etc/letsencrypt/live/$POSTFIX_FQDN/privkey.pem

if [ -f $CERTIFICATE -a -f $PRIVATE_KEY ]; then
    cerbot -n renew
else
    certbot -n certonly
fi
