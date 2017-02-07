# Install Nginx to reverse-proxy our nodejs app.
sudo apt-get -qq --assume-yes install nginx > /dev/null

# Delete the sample Nginx default server block.
sudo rm $NGINX_SERVER_BLOCK_LOCATION

# Replace the server block we just deleted with the configuration to reverse proxy to your app.

if [ "$LetsEncrypt_ENABLED" = "true" ]; then

    # Create configuration snippet to configure the required key files
    echo "ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;" | sudo tee --append $SSL_SITE_CONFIG_FILE > /dev/null
    echo "ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;" | sudo tee --append $SSL_SITE_CONFIG_FILE > /dev/null

    # Create configuration snippet to configure the required key files
    echo "ssl_protocols TLSv1 TLSv1.1 TLSv1.2;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_prefer_server_ciphers on;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_ecdh_curve secp384r1;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_session_cache shared:SSL:10m;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_session_tickets off;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_stapling on;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_stapling_verify on;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "resolver 8.8.8.8 8.8.4.4 valid=300s;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "resolver_timeout 5s;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "add_header Strict-Transport-Security \"max-age=63072000; includeSubdomains\";" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "add_header X-Frame-Options DENY;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "add_header X-Content-Type-Options nosniff;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null
    echo "ssl_dhparam /etc/ssl/certs/dhparam.pem;" | sudo tee --append $SSL_PARAMS_FILE > /dev/null

    # Create the server blocks
    echo "server {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen 80;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen [::]:80 default_server ipv6only=on;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    server_name $DOMAIN_NAME;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    return 301 https://\$host\$request_uri;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "}" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "server {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen 443;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    location ~ /.well-known{" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        allow all;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    }" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "}" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "server {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen 443 ssl http2 default_server;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen [::]:443 ssl http2 default_server;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    include snippets/ssl-$DOMAIN_NAME.conf;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    include snippets/ssl-params.conf;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    location / {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header X-Real-IP \$remote_addr;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header X-NginX-Proxy true;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_pass http://localhost:8080/;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_ssl_session_reuse off;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Host \$http_host;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_cache_bypass \$http_upgrade;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_redirect off;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    }" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "}" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
else

if [ "$SERVER_TYPE" = "dotnet" ]; then
    echo "server {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen 80;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    server_name $DOMAIN_NAME;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    location / {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_pass http://localhost:5001;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_http_version 1.1;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Upgrade \$http_upgrade;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Connection 'upgrade';" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Host \$host;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_cache_bypass \$http_upgrade;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    }" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "}" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
fi

if [ "$SERVER_TYPE" = "nodejs" ]; then
    echo "server {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    listen 80;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    server_name $DOMAIN_NAME;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    location / {" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_pass http://localhost:8080;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_http_version 1.1;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Upgrade \$http_upgrade;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Connection 'upgrade';" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_set_header Host \$host;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "        proxy_cache_bypass \$http_upgrade;" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "    }" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
    echo "}" | sudo tee --append $NGINX_SERVER_BLOCK_LOCATION > /dev/null
fi
    
fi

# Allow full permission to Nginx in the firewall.
sudo ufw allow 'Nginx Full'