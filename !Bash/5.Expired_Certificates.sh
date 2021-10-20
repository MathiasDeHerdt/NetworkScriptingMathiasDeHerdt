#!/bin/bash

# See if script is running as root
if [ "$(id -u)" -ne 0 ]; then

echo 'This script must be run by root' >&2
echo ""
echo "Stopping the script ..."

exit 1
fi