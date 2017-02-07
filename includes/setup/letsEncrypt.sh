# Install LetsEncrypt to generate our SSL certificate.
sudo apt-get -qq --assume-yes install letsencrypt > /dev/null

# Stop the Nginx service. This is required by LetsEncrypt to validate we own the domain name.
sudo systemctl stop nginx

sudo letsencrypt -d $DOMAIN_NAME --agree-tos --email $SSL_REGISTRATION_EMAIL certonly

if [ "$LetsEncrypt_AUTO_RENEW_ENABLED" = "true" ]; then
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
fi

sudo systemctl start nginx

if [ "$LetsEncrypt_AUTO_RENEW_ENABLED" = "true" ]; then
    crontab -l | { cat; echo "30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log"; } | crontab -
    crontab -l | { cat; echo "35 2 * * 1 /bin/systemctl reload nginx"; } | crontab -
fi