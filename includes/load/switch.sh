# Flag indicating if a monitor service has been installed.

DebugInfo "Loading switches..."

StartAndMonitorApp_FLAG = "false";
InitInfo "StartAndMonitorApp_FLAG" "$StartAndMonitorApp_FLAG"


if [ "$PM2_ENABLED" = "true" ]; then
    StartAndMonitorApp_FLAG="true";
    ChangeInfo "StartAndMonitorApp_FLAG" "$StartAndMonitorApp_FLAG"
    set "StartAndMonitorApp_FLAG" "true"
fi

DebugInfo "Switches loaded."