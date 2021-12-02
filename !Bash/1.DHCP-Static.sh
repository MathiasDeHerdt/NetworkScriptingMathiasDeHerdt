#!/bin/bash

printf "==============================================="
printf "                 DHCP - Static Script                 "
printf "===============================================\n\n"

# Variables
DHCP="dhcp"
STATIC="static"

# ***
# See if script is running as root
# ***

if [ "$(id -u)" -ne 0 ]; then

  printf "This script must be run by root" >&2
  printf "Stopping the script ..."

  exit 1

fi

# ***
# See if the parameters are empty or not
# ***

if [ -z "$1" ]
then
    # Stopping the script when there is no parameter
    printf "No parameter detected!"
    printf "Paramters are: dhcp or static"
    printf "  Example: sudo sh 1.DHCP-Static.sh dhcp\n\n"
    printf "Stopping the script ..."
    exit 2
else
    PARAM=$1
fi

# ***
# Function - Toggle to dhcp
# ***

toggle_dhcp () {
    printf "iface lo inet loopback\nauto lo\n\nauto ens192\niface ens192 inet dhcp\n" > /etc/network/interfaces

    printf "-------------------"
    printf "IP is set to DHCP"
    printf "-------------------\n\n"

    CMD_IP="ip a"
    CMD_RESTART="systemctl restart networking.service"

    sleep 2

    eval "$CMD_RESTART"
    printf ""
    eval "$CMD_IP"
}

# ***
# Function - Toggle to static
# ***

toggle_static () {
    INTERFACE="ens192"
    IPADDRESS="192.168.1.121"
    IPSUBNET="255.255.255.0"
    IPGATEWAY="192.168.1.1"

    echo "iface lo inet loopback\nauto lo\n\nauto $INTERFACE\nallow-hotplug $INTERFACE\niface $INTERFACE inet static\naddress $IPADDRESS\nnetmask $IPSUBNET\ngateway $IPGATEWAY\n" > /etc/network/interfaces

    printf "-------------------"
    printf "IP is set to static"
    printf "-------------------\n\n"

    CMD_IP="ip a"
    CMD_RESTART="systemctl restart networking.service"

    sleep 2

    eval "$CMD_RESTART"
    printf ""
    eval "$CMD_IP"
}

# ***
# See if parameter is 'dhcp' or 'static'
# ***

if [ "$PARAM" = "$DHCP" ]
then
    toggle_dhcp

elif [ "$PARAM" = "$STATIC" ]
then
    toggle_static

else
    printf "Parameter is '$PARAM', must be 'dhcp' or 'static'\n\n"
    printf "Stopping the script ..."
    exit 3

fi