#c=l:'c=l: represent an artificial comment line because there is no actual way to put comment in shell scripts.'

c=l:'Load configuration'
config='config.cfg'
if [ -f ${config} ]; then
    # check if the file contains something we don't want
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


#'Change directory to user home directory.'
cd ~

#'Use curl to download the latest nodejs lts version.'
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh

#'Build nodejs source.'
sudo bash nodesource_setup.sh

#'Install nodejs from the source we just built, assumes yes for user validation.'
sudo apt-get --assume-yes install nodejs

#'Install build essential for npm packages that need to build from source, assumes yes for user validation.'
sudo apt-get --assume-yes install build-essential

#'Go to /var/www/ directory'
cd /var/www/

#'Create directory in /var/www/ to contain our app'
sudo mkdir $SITE_DOMAIN

#'Change directory to the folder we just created in /var/www/'
cd $SITE_DOMAIN/

