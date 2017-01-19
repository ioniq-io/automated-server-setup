c=l:'c=l: represent an artificial comment line because there is no actual way to put comment in shell scripts.'

LetsEncrypt_ENABLED="false"

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

c=l:'Go to /var/www/ directory'
cd /var/www/

c=l:'Create directory in /var/www/ to contain our app'
sudo mkdir $SITE_DOMAIN

c=l:'Change directory to the folder we just created in /var/www/'
cd $SITE_DOMAIN/

