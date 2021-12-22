#!/bin/bash

printf "====================================================================\n"
printf "This script will edit the firstrun.sh on the Raspberry Pi with Bash\n"
printf "====================================================================\n\n"

# ***
# Variables
# ***
FILENAME="firstrun.sh"

# ***
# See if script is executed with sudo rights (or root)
# ***
if [ "$(id -u)" -ne 0 ]; then

  printf "Script must be executed with sudo!\n\n"

  exit 1

fi

# ***
# See firstrun.sh is in the same directory as this script
# ***
printf "Checking if the file exists...\n\n"
if [ -f $FILENAME ]
then
    printf "    -> OK! $FILENAME exists.\n\n"
else
    printf "    -> ERROR! $FILENAME does not exist."
    printf "              Please execute this script in the same directory as firstrun.sh.\n\n"
    printf "Stopping the script ...\n\n"
    printf "==============================================="
    exit 3
fi

# ***
# Create backup of firstrun.sh
# ***
printf "Creating backup file for firstrun.sh\n\n"
CMD_BAKUP="cp firstrun.sh firstrun.sh.bak"
eval "$CMD_BAKUP"
printf "Backup complete\n\n"

# ***
# Edit the firstrun.sh file
#   Documentation:
#       https://stackoverflow.com/questions/32007152/insert-multiple-lines-of-text-before-specific-line-using-bash
# ***
sed -i '/firstrun.sh/ i # \
# MCT - Computer Networks section # \
# \
# DHCP fallback profile \
profile static_eth0 \
static ip_address=192.168.168.168/24 \
\
# The primary network interface \
interface eth0 \
arping 192.168.99.99 \
fallback static_eth0 \
DHCPCDEOF' $FILENAME