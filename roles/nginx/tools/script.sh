#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $KEY \
    -out $CRT \
    -subj "/C=MA/ST=Benguerir/L=Benguerir/O=42/OU=1337/CN=$DOMAIN_NAME"    

sed -i  "s#ssl_crt#$CRT#" \
/etc/nginx/sites-available/default
sed -i  "s#ssl_key#$KEY#" \
/etc/nginx/sites-available/default
sed -i  "s#domaine_name#$DOMAIN_NAME#" \
/etc/nginx/sites-available/default

exec nginx -g "daemon off;"

