#!/bin/bash

source "../includes/load/config.sh"
source "../includes/load/functions.sh"
source "../includes/load/flags.sh"

pwd

source "../includes/initialize.sh"

pwd

source "../includes/wrapper/serverSetupWrapper.sh"

pwd

source "../includes/wrapper/serviceSetupWrapper.sh"

pwd

source "../includes/wrapper/reverseProxySetupWrapper.sh"

pwd

source "../includes/wrapper/sslSetupWrapper.sh"

pwd

source "../includes/wrapper/sampleAppSetupWrapper.sh"

pwd

source "../includes/finalize.sh"

pwd