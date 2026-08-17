#!/bin/sh
set -e

# Substitute environment variables into the Nginx template
envsubst '${CATALOGUE_HOST} ${USER_HOST} ${CART_HOST} ${SHIPPING_HOST} ${PAYMENT_HOST} ${RATINGS_HOST}' \
  < /etc/nginx/conf.d/default.conf.template \
  > /etc/nginx/conf.d/default.conf

# Start Nginx in the foreground
exec nginx -g 'daemon off;'
