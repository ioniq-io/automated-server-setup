PROJECT_PATH="­­~/automated-server-setup"

# Load configuration file
pwd
config="$PROJECT_PATH/config.cfg"
if [ -f ${config} ]; then
    # Validate the configuration file syntax
    CFG_SYNTAX="(^\s*#|^\s*$|^\s*[a-z_][^[:space:]]*=[^;&]*$)"
    if egrep -q -iv "$CONFIG_SYNTAX" "$config"; then
      echo "[ERROR]: Configuration file format is invalid." >&2
      exit 1
    fi
    # now source it, either the original or the filtered variant
    source "$config"
else
    echo "There is no configuration file call ${config}"
fi