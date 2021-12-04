  #!/bin/bash

  printf "==============================================="
  printf "                 Alias record Script           "
  printf "===============================================\n\n"

  # variables
  PKG_TO_INSTALL="apache2 bind9 bind9utils bind9-doc"
  NR_OF_PKG="4"
  ADJUST_BIND9="OPTIONS='-4 -u bind'"
  NMCTINTERNAL_BE="/etc/bind/zones/nmctinternal.be"
  REVERSE_ARPA="/etc/bind/zones/reverse/1.168.192.in-addr.arpa"
  NAMED_CONF_LOCAL="/etc/bind/named.conf.local"

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

  echo "#\n# run resolv.conf?\nRESOLVCONF=no\n\n# startup options for the server\nOPTIONS=$ADJUST_BIND9" >/etc/default/bind9
  printf "  - Edited the bind9 file\n\n"

  # ***
  # adjust /etc/bind/named.conf.local
  # ***

  printf "Creating backup file for named.conf.local\n\n"
  CMD_BAK_NAMED="cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak"
  eval "$CMD_BAK_NAMED"
  printf "Backup complete\n\n"

  printf "Adding lines to named.conf.local\n\n"
  printf "zone \" nmctinternal.be\" {\n type master;\nfile \"/etc/bind/zones/nmctinternal.be\";\n};\n\n" >>${NAMED_CONF_LOCAL}
  printf "zone \"1.168.192.in-addr.arpa\" {\ntype master;\n file \"/etc/bind/zones/reverse/1.168.192.in-addr.arpa\";\n};" >>${NAMED_CONF_LOCAL}

  printf "" >>${NAMED_CONF_LOCAL}

  printf "Success adding lines!\n\n"

  # ***
  # create zone directory and adjusting the files
  # ***

  printf "Creating /etc/bind/zones/reverse\n\n"
  CMD_MKDIR_ZONES="mkdir -p /etc/bind/zones/reverse"
  eval "$CMD_MKDIR_ZONES"
  printf "Done creating directory\n\n"

  printf "Creating file nmctinternal.be in /etc/bind/zones/\n\n"
  touch ${NMCTINTERNAL_BE}

  printf "Adjusting nmctinternal.be"
  echo ";" >>${NMCTINTERNAL_BE}
  echo "; BIND data for nmctinternal.be" >>${NMCTINTERNAL_BE}
  echo ";" >>${NMCTINTERNAL_BE}
  printf "\$TTL 3h\n" >>${NMCTINTERNAL_BE}
  echo "@       IN      SOA     ns1.nmctinternal.be. admin.nmctinternal.be. (" >>${NMCTINTERNAL_BE}
  echo "                        1       ; serial" >>${NMCTINTERNAL_BE}
  echo "                        3h      ; refresh" >>${NMCTINTERNAL_BE}
  echo "                        1h      ; retry" >>${NMCTINTERNAL_BE}
  echo "                        1w      ; expire" >>${NMCTINTERNAL_BE}
  echo "                        1h )    ; minimum" >>${NMCTINTERNAL_BE}
  echo ";" >>${NMCTINTERNAL_BE}
  echo "@       IN      NS      ns1.nmctinternal.be." >>${NMCTINTERNAL_BE}
  echo "" >>${NMCTINTERNAL_BE}
  echo "www                     IN      CNAME   nmctinternal.be." >>${NMCTINTERNAL_BE}

  printf "Creating file 1.168.192.in-addr.arpa in /etc/bind/zones/reverse/\n\n"
  touch ${REVERSE_ARPA}

  printf "Adjusting reverse lookup zone\n\n"
  echo ";" >>${REVERSE_ARPA}
  echo "; BIND reverse file for 1.168.192.in-addr.arpa" >>${REVERSE_ARPA}
  echo ";" >>${REVERSE_ARPA}
  printf "\$TTL    604800\n" >>${REVERSE_ARPA}
  echo "@       IN      SOA     ns1.nmctinternal.be. admin.nmctinternal.be. (" >>${REVERSE_ARPA}
  echo "                                1       ; serial" >>${REVERSE_ARPA}
  echo "                                3h      ; refresh" >>${REVERSE_ARPA}
  echo "                                1h      ; retry" >>${REVERSE_ARPA}
  echo "                                1w      ; expire" >>${REVERSE_ARPA}
  echo "                                1h )    ; minimum" >>${REVERSE_ARPA}
  echo ";" >>${REVERSE_ARPA}
  echo "@       IN      NS      ns1.nmctinternal.be." >>${REVERSE_ARPA}

  # ***
  # Restarting bind9
  # ***

  systemctl restart bind9
  printf "Script ended successfully\n\n"