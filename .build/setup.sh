#!/usr/bin/env bash

##-------------------------------------------------------
# SETUP SELF SIGNED SSL CERTIFICATES
##-------------------------------------------------------
mkdir -p /etc/nginx/certs.d
openssl req -nodes -x509 -newkey rsa:4096 -keyout /etc/nginx/certs.d/localhost.key -out /etc/nginx/certs.d/localhost.cer -days 356 -subj /C=AU/ST=NSW/L=Sydney/O=IT/CN=localhost.com
