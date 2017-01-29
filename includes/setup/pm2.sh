# Install PM2 to monitor our nodejs application.
sudo npm -g --silent install pm2 > /dev/null

cd "$WEB_DIRECTORY"
# Start the nodejs application with PM2. The application will auto-restart from this point.
pm2 start $SITE_INIT_FILE_NAME > /dev/null

# Set PM2 to start on system startup.
sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER_WITH_ROOT_ACCESS --hp /home/$USER_WITH_ROOT_ACCESS" > /dev/null