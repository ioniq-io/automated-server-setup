if [ "$SERVER_TYPE" = "nodejs" ]; then
    LoadSource "$SCRIPT_PATH/includes/write/sampleApp/nodeJsHelloWorld.sh"
fi

if [ "$SERVER_TYPE" = "dotnet" ]; then
    LoadSource "$SCRIPT_PATH/includes/write/sampleApp/dotnetSampleApp.sh"
fi