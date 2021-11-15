docker run -it --rm --name certbot \
    -v "$(pwd)/scripts/certs/etc/:/etc/letsencrypt" \
    -v "$(pwd)/scripts/certs/lib/:/var/lib/letsencrypt" \
    -v "$(pwd)/config/:/config/" \
    certbot/dns-linode certonly \
        --agree-tos -n -m devops@mbaza.digital \
        --dns-linode \
        --dns-linode-credentials /config/linode.ini \
        --dns-linode-propagation-seconds 60 \
        -d dev.mbaza.digital

cat "$(pwd)/scripts/certs/etc/live/dev.mbaza.digital/fullchain.pem"
echo "$(pwd)"
cp "$(pwd)/scripts/certs/etc/live/dev.mbaza.digital/fullchain.pem" "$(pwd)/certificates/fullchain.pem"
cp "$(pwd)/scripts/certs/etc/live/dev.mbaza.digital/privkey.pem"  "$(pwd)/certificates/privkey.pem"