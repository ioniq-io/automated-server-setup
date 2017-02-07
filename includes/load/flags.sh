#!/bin/bash
# Flags

while getopts ":a:" opt; do
  case $opt in
    a)
      echo "-a was triggered, Parameter: $OPTARG" >&2
      ;;
    -system)
      if [ "$OPTARG" = "ubuntu" ]; then
        echo "System is ubuntu."
        SYSTEM_TYPE="ubuntu"
      fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done