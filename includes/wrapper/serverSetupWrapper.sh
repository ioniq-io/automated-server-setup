if [ "$SERVER_TYPE" = "nodejs" ]; then
    LoadSource "$SCRIPT_PATH/includes/setup/nodeJS.sh"
fi

if [ "$SERVER_TYPE" = "dotnet" ]; then
    LoadSource "$SCRIPT_PATH/includes/setup/dotnet.sh"
fi