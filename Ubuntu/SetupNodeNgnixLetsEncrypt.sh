# Load configuration file
config='config.cfg'
if [ -f ${config} ]; then
    # Validate the configuration file syntax
    CFG_SYNTAX="(^\s*#|^\s*$|^\s*[a-z_][^[:space:]]*=[^;&]*$)"
    if egrep -q -iv "$CONFIG_SYNTAX" "$config"; then
      echo "[ERROR]: Configuration file format is invalid." >&2
      exit 1
    fi
    # now source it, either the original or the filtered variant
    source "$config"
else
    echo "There is no configuration file call ${config}"
fi


# Change directory to user home directory.
cd ~

# Update apt-get cache
sudo apt-get update > /dev/null



if [ "$SERVER_TYPE" = "nodejs" ]; then
    # Use curl to download the latest nodejs lts version.
    curl --Silent --location https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh > /dev/null

    # Build nodejs source.
    sudo bash nodesource_setup.sh > /dev/null

    # Install nodejs from the source we just built, assumes yes for user validation.
    sudo apt-get -qq --assume-yes install nodejs > /dev/null

    # Install build essential for npm packages that need to build from source, assumes yes for user validation.
    sudo apt-get -qq --assume-yes install build-essential > /dev/null
fi

if [ "$SERVER_TYPE" = "dotnet" ]; then
    sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
    sudo apt-get update
    sudo apt-get install dotnet-dev-1.0.0-preview2.1-003177

    mkdir hwapp
    cd hwapp
    dotnet new
    dotnet restore
    dotnet run
fi

# Check if the directory for the app already exist and if not, creates it
if [ ! -d "$WEB_DIRECTORY" ]; then
    sudo mkdir -p $WEB_DIRECTORY
fi

if [ "$SERVER_TYPE" = "nodejs" ]; then
    # Create your nodejs entry file that will be monitored by PM2.
    echo "#!/usr/bin/env nodejs" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
    echo "var http = require('http');" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
    echo "http.createServer(function (req, res) {" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
    echo "  res.writeHead(200, {'Content-Type': 'text/plain'});" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
    echo "  res.end('Hello World\n');" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
    echo "}).listen(8080, 'localhost');" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
    echo "console.log('Server running at http://localhost:8080/');" | sudo tee --append $WEB_DIRECTORY/$SITE_INIT_FILE_NAME > /dev/null
fi

if [ "$PM2_ENABLED" = "true" ]; then
    # Install PM2 to monitor our nodejs application.
    sudo npm -g --silent install pm2 > /dev/null

    cd "$WEB_DIRECTORY"
    # Start the nodejs application with PM2. The application will auto-restart from this point.
    pm2 start $SITE_INIT_FILE_NAME > /dev/null

    # Set PM2 to start on system startup.
    sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER_WITH_ROOT_ACCESS --hp /home/$USER_WITH_ROOT_ACCESS" > /dev/null
fi

if [ "$NGINX_ENABLED" = "true" ]; then
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

    # Allow full permission to Nginx in the firewall.
    sudo ufw allow 'Nginx Full'
fi
# LetsEncrypt ENABLED flag condition.
if [ "$LetsEncrypt_ENABLED" = "true" ]; then
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
fi

echo "Your nodejs web application is now fully configured."
echo "You can locate the app file with: cd $WEB_DIRECTORY"