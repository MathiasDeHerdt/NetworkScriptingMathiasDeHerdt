#!/bin/bash

# Variables
DHCP="dhcp"
STATIC="static"

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
    echo "No parameter detected!"
    echo "Paramters are: dhcp or static"
    echo "  Example: sudo sh 1.DHCP-Static.sh dhcp"
    echo ""
    echo "Stopping the script ..."
    exit 2
else
    PARAM=$1
fi


# Function - Toggle to dhcp
toggle_dhcp () {
    echo "dhcp baby"
}

# Function - Toggle to static
toggle_static () {
    echo "static baby"
}

# See if parameter is 'dhcp' or 'static'
if [ "$PARAM" = "$DHCP" ]
then
    toggle_dhcp

elif [ "$PARAM" = "$STATIC" ]
then 
    toggle_static
    
else
    echo "Parameter is '$PARAM', must be 'dhcp' or 'static'"
    echo ""
    echo "Stopping the script ..."
    exit 3

fi