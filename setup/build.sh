#!/bin/bash

source "../includes/load/config.sh"
source "../includes/load/functions.sh"
source "../includes/load/flags.sh"

source "../includes/initialize.sh"

source "../includes/wrapper/serverSetupWrapper.sh"

source "../includes/wrapper/serviceSetupWrapper.sh"

source "../includes/wrapper/reverseProxySetupWrapper.sh"

source "../includes/wrapper/sslSetupWrapper.sh"

source "../includes/wrapper/sampleAppSetupWrapper.sh"

source "../includes/finalize.sh"