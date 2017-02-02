# Flag indicating if a monitor service has been installed.

Debug_Info "Loading switches..."

StartAndMonitorApp_FLAG = "false";
InitInfo "StartAndMonitorApp_FLAG" "$StartAndMonitorApp_FLAG"


if [ "$PM2_ENABLED" = "true" ]; then
    StartAndMonitorApp_FLAG = "true";
    ChangeInfo "StartAndMonitorApp_FLAG" "$StartAndMonitorApp_FLAG"
fi

Debug_Info "Switches loaded.