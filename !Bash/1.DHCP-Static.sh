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
    echo "iface lo inet loopback\nauto lo\n\nauto ens192\niface ens192 inet dhcp\n" > /etc/network/interfaces

    echo "-------------------"
    echo "IP is set to DHCP"
    echo "-------------------"
    echo ""

    CMDIP="ip a"
    CMDRESTART="systemctl restart networking.service"

    sleep 2

    eval $CMDRESTART
    echo ""
    eval $CMDIP
}

# Function - Toggle to static
toggle_static () {
    INTERFACE="ens192"
    IPADDRESS="192.168.1.121"
    IPSUBNET="255.255.255.0"
    IPGATEWAY="192.168.1.1"

    echo "iface lo inet loopback\nauto lo\n\nauto $INTERFACE\nallow-hotplug $INTERFACE\niface $INTERFACE inet static\naddress $IPADDRESS\nnetmask $IPSUBNET\ngateway $IPGATEWAY\n" > /etc/network/interfaces

    echo "-------------------"
    echo "IP is set to static"
    echo "-------------------"
    echo ""

    CMDIP="ip a"
    CMDRESTART="systemctl restart networking.service"

    sleep 2

    eval $CMDRESTART
    echo ""
    eval $CMDIP
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