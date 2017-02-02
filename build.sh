#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd -P`
popd > /dev/null

source "$SCRIPT_PATH/includes/load/functions.sh"

DebugInfo "SCRIPT_PATH = $SCRIPT_PATH"

LoadSource "$SCRIPT_PATH/includes/load/config.sh"

DebugInfo "Config loaded successfully."

LoadSource "$SCRIPT_PATH/includes/load/flags.sh"

DebugInfo "Flags loaded successfully."

LoadSource "$SCRIPT_PATH/includes/initialize.sh"

DebugInfo "Setup initialized."

LoadSource "$SCRIPT_PATH/includes/wrapper/serverSetupWrapper.sh"

LoadSource "$SCRIPT_PATH/includes/wrapper/serviceSetupWrapper.sh"

LoadSource "$SCRIPT_PATH/includes/wrapper/reverseProxySetupWrapper.sh"

LoadSource "$SCRIPT_PATH/includes/wrapper/sslSetupWrapper.sh"

LoadSource "$SCRIPT_PATH/includes/wrapper/sampleAppSetupWrapper.sh"

LoadSource "$SCRIPT_PATH/includes/finalize.sh"

DebugInfo "Setup finalized."