if [ "$NGINX_ENABLED" = "true" ]; then
    LoadSource "$SCRIPT_PATH/includes/setup/nginx.sh"
fi