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

# Use curl to download the latest nodejs lts version.
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh

# Build nodejs source.
sudo bash nodesource_setup.sh

# Install nodejs from the source we just built, assumes yes for user validation.
sudo apt-get -qq --assume-yes install nodejs

# Install build essential for npm packages that need to build from source, assumes yes for user validation.
sudo apt-get -qq --assume-yes install build-essential

# Check if the directory for the app already exist and if not, creates it
if [ ! -d "$WEB_DIRECTORY" ]; then
    sudo mkdir -p "$WEB_DIRECTORY"
fi

cd "$WEB_DIRECTORY"

# Create your nodejs entry file that will be monitored by PM2.
echo "#!/usr/bin/env nodejs" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null
echo "var http = require('http');" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null
echo "http.createServer(function (req, res) {" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null
echo "  res.writeHead(200, {'Content-Type': 'text/plain'});" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null
echo "  res.end('Hello World\n');" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null
echo "}).listen(8080, 'localhost');" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null
echo "console.log('Server running at http://localhost:8080/');" | sudo tee --append /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME > /dev/null

# Install PM2 to monitor our nodejs application.
sudo npm install -g --assume-yes pm2

# Start the nodejs application with PM2. The application will auto-restart from this point.
pm2 start $SITE_INIT_FILE_NAME

# Set PM2 to start on system startup.
sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER_WITH_ROOT_ACCESS --hp /home/$USER_WITH_ROOT_ACCESS"

# Install Nginx to reverse-proxy our nodejs app.
sudo apt-get --assume-yes install nginx

# Delete the sample Nginx default server block.
sudo rm /etc/nginx/sites-available/default

# Replace the server block we just deleted with the configuration to reverse proxy to your app.
echo "server {" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "    listen 80;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "    server_name example.com;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "    location / {" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "        proxy_pass http://localhost:8080;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "        proxy_http_version 1.1;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "        proxy_set_header Upgrade \$http_upgrade;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "        proxy_set_header Connection 'upgrade';" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "        proxy_set_header Host \$host;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "        proxy_cache_bypass \$http_upgrade;" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "    }" | sudo tee --append /etc/nginx/sites-available/default > /dev/null
echo "}" | sudo tee --append /etc/nginx/sites-available/default > /dev/null

# Restart Nginx to apply the new server block we just created.
sudo systemctl restart nginx

# Allow full permission to Nginx in the firewall.
sudo ufw allow 'Nginx Full'

# LetsEncrypt ENABLED flag condition.
if [ "$LetsEncrypt_ENABLED" = "true" ]; then
    # Install LetsEncrypt to generate our SSL certificate.
    sudo apt-get install letsencrypt

    # Stop the Nginx service. This is required by LetsEncrypt to validate we own the domain name.
    sudo systemctl stop nginx
    
    sudo letsencrypt certonly --standalone
fi

echo "Your nodejs web application is now fully configured."
echo "You can locate the app file with: cd $WEB_DIRECTORY"