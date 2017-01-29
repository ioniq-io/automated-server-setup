if [ "$SERVER_TYPE" = "nodejs" ]; then
    source "$SCRIPT_PATH/includes/setup/nodeJS.sh"
fi

if [ "$SERVER_TYPE" = "dotnet" ]; then
    source "$SCRIPT_PATH/includes/setup/dotnet.sh"
fi