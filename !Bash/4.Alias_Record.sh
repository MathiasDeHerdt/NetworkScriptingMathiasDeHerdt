#!/bin/bash

printf "==============================================="
printf "                 Alias record Script                 "
printf "===============================================\n\n"

# variables
PKG_TO_INSTALL="apache2 bind9 bind9utils bind9-doc"
NR_OF_PKG="4"
ADJUST_BIND9="OPTIONS='-4 -u bind'"

# ***
# See if script is running as root
# ***

if [ "$(id -u)" -ne 0 ]; then

  printf "This script must be run by root\n\n"
  printf "Stopping the script ..."

  exit 1

fi

# ***
# update and install packages
# ***

printf "Updating...\n\n"
apt update # To get the latest package lists
printf "Updating complete! Upgrading...\n\n"
apt upgrade
printf "Upgrade complete! Installing ${NR_OF_PKG} packages"
apt install ${PKG_TO_INSTALL} -y
printf "Installing packages complete!\n\n"

# ***
# adjust /etc/default/bind9
# ***

printf "Creating backup file for bind9\n\n"

CMD_BAK_BIND9="cp /etc/default/bind9 /etc/default/bind9.bak"
eval "$CMD_BAK_BIND9"
printf "Backup complete\n\n"

printf "#\n# run resolv.conf?\nRESOLVCONF=no\n\n# startup options for the server\nOPTIONS=$ADJUST_BIND9" >/etc/default/bind9
printf "  - Edited the bind9 file\n\n"

# ***
# adjust /etc/bind/named.conf.local
# ***

printf "Creating backup file for named.conf.local\n\n"
CMD_BAK_NAMED="cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak"
eval "$CMD_BAK_NAMED"
printf "Backup complete\n\n"

printf "Adding lines to named.conf.local\n\n"

printf 'zone " mctinternal.be" {' >>/etc/bind/named.conf.local
printf "      type master;" >>/etc/bind/named.conf.local
printf '      file "/etc/bind/zones/ mctinternal.be";' >>/etc/bind/named.conf.local
printf "};" >>/etc/bind/named.conf.local

printf "" >>/etc/bind/named.conf.local

printf 'zone "X.168.192.in-addr.arpa" {' >>/etc/bind/named.conf.local
printf "      type master;" >>/etc/bind/named.conf.local
printf '     file "/etc/bind/zones/reverse/rev.X.168.192";' >>/etc/bind/named.conf.local
printf "};" >>/etc/bind/named.conf.local

# ***
# create zone directory
# ***

printf "Creating /etc/bind/zones/reverse\n\n"
CMD_MKDIR_ZONES="mkdir -p /etc/bind/zones/reverse"
# eval "$CMD_MKDIR_ZONES"
printf "Done creating directory\n\n"

printf "Creating file in /etc/bind/zones\n\n"
CMD_TOUCH_MCT="touch /etc/bind/zones/mctinternal.be"
# eval "$CMD_TOUCH_MCT"
printf "Done creating file\n\n"
