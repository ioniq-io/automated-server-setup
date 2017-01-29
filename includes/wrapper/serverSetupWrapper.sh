if [ "$SERVER_TYPE" = "nodejs" ]; then
    source "../includes/setup/nodeJS.sh"
fi

if [ "$SERVER_TYPE" = "dotnet" ]; then
    source "../includes/setup/dotnet.sh"
fi