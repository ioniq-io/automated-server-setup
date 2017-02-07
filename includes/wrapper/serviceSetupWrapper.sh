if [ "$StartAndMonitorApp_FLAG" = "true" ]; then

    # Setup PM2 as the application service manager
    if [ "$PM2_ENABLED" = "true" ]; then
        LoadSource "$SCRIPT_PATH/includes/setup/pm2.sh"
    fi

fi