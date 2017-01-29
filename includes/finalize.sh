if [ "$NGINX_ENABLED" = "true" ]; then
    sudo systemctl stop nginx
    sudo systemctl start nginx
fi

echo "Your application is now fully configured."
echo "You can locate the app file with: cd $WEB_DIRECTORY"