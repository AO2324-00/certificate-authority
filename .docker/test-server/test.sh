#!/bin/bash

command="curl -v -I https://$DNS/ --cacert /ca-cert.pem"

nginx

echo "0.0.0.0   $DNS" >> /etc/hosts && \
sleep 1 && \
echo -e "\n\ncurl -v -I https://$DNS/ --cacert /ca-cert.pem\n" && \
curl -v https://$DNS/ --cacert /ca-cert.pem && \
nginx -s quit