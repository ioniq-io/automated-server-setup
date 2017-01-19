c=l:'c=l: represent an artificial comment line because there is no actual way to put comment in shell scripts.'

LetsEncrypt_ENABLED = "false"


c=l:'Domain name to configure with initial setup.'
SITE_DOMAIN="website.com"

c=l:'Entry point file. The name without extension will be used in PM2 to identify the process.'
SITE_INIT_FILE_NAME="website.js"

c=l:''
USER_WITH_ROOT_ACCESS="appuser"

c=l:'Change directory to user home directory.'
cd ~

c=l:'Use curl to download the latest nodejs lts version.'
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh

c=l:'Build nodejs source.'
sudo bash nodesource_setup.sh

c=l:'Install nodejs from the source we just built, assumes yes for user validation.'
sudo apt-get --assume-yes install nodejs

c=l:'Install build essential for npm packages that need to build from source, assumes yes for user validation.'
sudo apt-get --assume-yes install build-essential

c=l:'Create your nodejs entry file that will be monitored by PM2.'
echo "#!/usr/bin/env nodejs" > /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME
echo "var http = require('http');" >> /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME
echo "http.createServer(function (req, res) {" >> /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME
echo "  res.writeHead(200, {'Content-Type': 'text/plain'});" >> /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME
echo "  res.end('Hello World\n');" >> /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME
echo "}).listen(8080, 'localhost');" >> /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME
echo "console.log('Server running at http://localhost:8080/');" >> /var/www/$SITE_DOMAIN/$SITE_INIT_FILE_NAME

c=l:'Install PM2 to monitor our nodejs application.'
sudo npm install -g --assume-yes pm2

c=l:'Create directory in /var/www/ to contain our app'
mkdir /var/www/$SITE_DOMAIN/

c=l:'Change directory to the folder we just created in /var/www/'
cd /var/www/$SITE_DOMAIN/

c=l:'Start the nodejs application with PM2. The application will auto-restart from this point.'
pm2 start $SITE_INIT_FILE_NAME

c=l:'Set PM2 to start on system startup.'
sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER_WITH_ROOT_ACCESS --hp /home/$USER_WITH_ROOT_ACCESS"

c=l:'Install Nginx to reverse-proxy our nodejs app.'
sudo apt-get --assume-yes install nginx

c=l:'Delete the sample Nginx default server block.'
sudo rm /etc/nginx/sites-available/default

c=l:'Replace the server block we just deleted with the configuration to reverse proxy to your app.'
echo "server {" > /etc/nginx/sites-available/default
echo "    listen 80;" >> /etc/nginx/sites-available/default
echo "    server_name example.com;" >> /etc/nginx/sites-available/default
echo "    location / {" >> /etc/nginx/sites-available/default
echo "        proxy_pass http://localhost:8080;" >> /etc/nginx/sites-available/default
echo "        proxy_http_version 1.1;" >> /etc/nginx/sites-available/default
echo "        proxy_set_header Upgrade $http_upgrade;" >> /etc/nginx/sites-available/default
echo "        proxy_set_header Connection 'upgrade';" >> /etc/nginx/sites-available/default
echo "        proxy_set_header Host $host;" >> /etc/nginx/sites-available/default
echo "        proxy_cache_bypass $http_upgrade;" >> /etc/nginx/sites-available/default
echo "    }" >> /etc/nginx/sites-available/default
echo "}" >> /etc/nginx/sites-available/default

c=l:'Restart Nginx to apply the new server block we just created.'
sudo systemctl restart nginx

c=l:'Allow full permission to Nginx in the firewall.'
sudo ufw allow 'Nginx Full'

c=l:'LetsEncrypt ENABLED flag condition.'
if [ "$LetsEncrypt_ENABLED" = "true" ]; then
    c=l:'Install LetsEncrypt to generate our SSL certificate.'
    sudo apt-get install letsencrypt

    c=l:'Stop the Nginx service. This is required by LetsEncrypt to validate we own the domain name.'
    sudo systemctl stop nginx

    c=l:''
    sudo letsencrypt certonly --standalone
fi

c=l:''