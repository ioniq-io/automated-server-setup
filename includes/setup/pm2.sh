
if [ "$SERVER_TYPE" != "nodejs" ]; then
    sudo apt-get -qq --assume-yes install npm
fi

# Install PM2 to monitor our nodejs application.
sudo npm -g --silent install pm2 > /dev/null

# Set PM2 to start on system startup.
#sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER_WITH_ROOT_ACCESS --hp /home/$USER_WITH_ROOT_ACCESS" > /dev/null
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER_WITH_ROOT_ACCESS --hp /home/$USER_WITH_ROOT_ACCESS