#!/bin/bash

printf "==============================================="
printf "               Expired Certificates               "
printf "===============================================\n\n"

# Variables
CRTSFILE="/home/mdh/bashing/certs/crts.txt"
EXPCRTSFILE="/home/mdh/bashing/certs/expcrts.txt"

# ***
# See if script is running as root
# ***

if [ "$(id -u)" -ne 0 ]; then

  printf "This script must be run by root" >&2
  printf "Stopping the script ..."

  exit 1

fi

>$EXPCRTSFILE

# ***
# add .crt filenames to txt file
# ***

find / -type f -name '*.crt' >>$CRTSFILE

Lines=$(cat $CRTSFILE)

for Line in $Lines; do
  DATE=$(openssl x509 -enddate -noout -in $Line)

  YEAR=${DATE:25:-4}
  MONTH=${DATE:9:-21}
  DAY=${DATE:13:-18}

  NEWDATE="$DAY-${MONTH^^}-$YEAR"

  EXPIREDATE=$(date -d "$NEWDATE" +"%s")
  DATEPLUSFOURTEEN=$(date -d "$dt +14 day" +"%s")
  CURRENTDATE=$(date +%s)

  if [ "$DATEPLUSFOURTEEN" -gt "$EXPIREDATE" ] && [ "$EXPIREDATE" -ge "$CURRENTDATE" ]; then
    echo "$Line" >>$EXPCRTSFILE
    echo "$Line"
  fi
done

# ***
# CRTSFILE verwijderen
# ***

rm -d $CRTSFILE