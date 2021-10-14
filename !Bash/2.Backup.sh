#!/bin/bash

# See if script is running as root
if [ "$(id -u)" -ne 0 ]; then

echo 'This script must be run by root' >&2
echo ""
echo "Stopping the script ..."

exit 1
fi

# See if the parameters are empty or not
if [ -z "$1" ]
then
    # Stopping the script when there is no parameter
    echo "No path to directory detected!"
    echo "  Example: sudo sh 2.backup.sh /etc/network/"
    echo ""
    echo "Stopping the script ..."
    exit 2
else
    PATH=$1
fi

# See if the path exists
if [ -d $PATH ] 
then
    echo "$PATH exists." 
else
    echo "Error: Directory $PATH does not exists."
    echo ""
    echo "Stopping the script ..."
    exit 3
fi