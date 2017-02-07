# Use curl to download the latest nodejs lts version.
curl --Silent --location https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh > /dev/null

# Build nodejs source.
sudo bash nodesource_setup.sh > /dev/null

# Install nodejs from the source we just built, assumes yes for user validation.
sudo apt-get -qq --assume-yes install nodejs > /dev/null

# Install build essential for npm packages that need to build from source, assumes yes for user validation.
sudo apt-get -qq --assume-yes install build-essential > /dev/null