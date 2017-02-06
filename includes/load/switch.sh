# Flag indicating if a monitor service has been installed.

DebugInfo "Loading switches..."

StartAndMonitorApp_FLAG="false";
InitInfo "StartAndMonitorApp_FLAG" "$StartAndMonitorApp_FLAG"


if [ "$PM2_ENABLED" = "true" ]; then
    StartAndMonitorApp_FLAG="true";
    ChangeInfo "StartAndMonitorApp_FLAG" "$StartAndMonitorApp_FLAG"
fi

if [ "$NGINX_ENABLED" = "true" ]; then
    ProxyEnabled_FLAG="true";
    ChangeInfo "ProxyEnabled_FLAG" "$ProxyEnabled_FLAG"
fi


DebugInfo "Switches loaded."