#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPT_PATH=`pwd -P`
popd > /dev/null

source "$SCRIPT_PATH/includes/load/config.sh"
source "$SCRIPT_PATH/includes/load/functions.sh"
source "$SCRIPT_PATH/includes/load/flags.sh"

source "$SCRIPT_PATH/includes/initialize.sh"

source "$SCRIPT_PATH/includes/wrapper/serverSetupWrapper.sh"

source "$SCRIPT_PATH/includes/wrapper/serviceSetupWrapper.sh"

source "$SCRIPT_PATH/includes/wrapper/reverseProxySetupWrapper.sh"

source "$SCRIPT_PATH/includes/wrapper/sslSetupWrapper.sh"

source "$SCRIPT_PATH/includes/wrapper/sampleAppSetupWrapper.sh"

source "$SCRIPT_PATH/includes/finalize.sh"