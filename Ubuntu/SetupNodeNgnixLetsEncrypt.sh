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
sudo apt-get --assume-yes install nodejs

# Install build essential for npm packages that need to build from source, assumes yes for user validation.
sudo apt-get --assume-yes install build-essential

# Go to /var/www/ directory
cd /var/www/

# Create directory in /var/www/ to contain our app
sudo mkdir $SITE_DOMAIN

if [ ! -d "$WEB_DIRECTORY" ]; then
    sudo mkdir -p "$WEB_DIRECTORY"
fi

cd $WEB_DIRECTORY

