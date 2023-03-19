#!/bin/bash
# takes two paramters, the domain name and the email to be associated with the certificate
DOMAIN=$1
EMAIL=$2

sudo rm -rf letsencrypt certbot .env
mkdir -p letsencrypt certbot log/nginx
#echo MARIADB_USER=matomo > .env
#echo MARIADB_PASSWORD=`openssl rand 30 | base64 -w 0` >> .env
#echo MARIADB_ROOT_PASSWORD=`openssl rand 30 | base64 -w 0` >> .env
echo DOMAIN=${DOMAIN} >> .env
echo EMAIL=${EMAIL} >> .env

source .env
# Phase 1
docker compose -f ./docker-compose-initiate.yaml up nginx -d
docker compose -f ./docker-compose-initiate.yaml up certbot
docker compose -f ./docker-compose-initiate.yaml down

# some configurations for let's encrypt

curl -L --create-dirs -o letsencrypt/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
openssl dhparam -out letsencrypt/ssl-dhparams.pem 2048

# Phase 2
crontab ./crontab
#docker compose -f ./docker-compose.yaml up -d
