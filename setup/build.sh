#!/bin/bash

source "../includes/load/config.sh"
source "$PROJECT_PATH/includes/load/functions.sh"
source "$PROJECT_PATH/includes/load/flags.sh"

pwd

source "$PROJECT_PATH/includes/initialize.sh"

pwd

source "$PROJECT_PATH/includes/wrapper/serverSetupWrapper.sh"

pwd

source "$PROJECT_PATH/includes/wrapper/serviceSetupWrapper.sh"

pwd

source "$PROJECT_PATH/includes/wrapper/reverseProxySetupWrapper.sh"

pwd

source "$PROJECT_PATH/includes/wrapper/sslSetupWrapper.sh"

pwd

source "$PROJECT_PATH/includes/wrapper/sampleAppSetupWrapper.sh"

pwd

source "$PROJECT_PATH/includes/finalize.sh"

pwd