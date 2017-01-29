if [ "$SERVER_TYPE" = "nodejs" ]; then
    source "$PROJECT_PATH/includes/setup/nodeJS.sh"
fi

if [ "$SERVER_TYPE" = "dotnet" ]; then
    source "$PROJECT_PATH/includes/setup/dotnet.sh"
fi