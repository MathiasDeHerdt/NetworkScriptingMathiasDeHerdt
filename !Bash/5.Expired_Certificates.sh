#!/bin/bash

printf "==============================================="
printf "               Expired Certificates               "
printf "===============================================\n\n"

# ***
# See if script is running as root
# ***

if [ "$(id -u)" -ne 0 ]; then

  printf 'This script must be run by root' >&2
  printf "Stopping the script ..."

  exit 1

fi

# ***
# add .crt file names to txt file
# ***

CERT_PATH="/home/mdh/bashing/certs/crts.txt"

find / -type f -name '*.crt' >>$CERT_PATH

File=$CERT_PATH
Lines=$(cat $File)

for Line in $Lines; do
  DATE=$(openssl x509 -enddate -noout -in $Line)

  YEAR=${DATE:25:-4}
  MONTH=${DATE:9:-21}
  DAY=${DATE:13:-18}

  NEW_DATE="$DAY-${MONTH^^}-$YEAR"

  printf "$NEW_DATE"

  EXPIRE_DATE=$(date -d "$NEW_DATE" +"%s")
  DATE_PLUS_FOURTEEN=$(date -d "$dt +14 day" +"%s")
  CURRENT_DATE=$(date +%s)

  printf "$EXPIRE_DATE"
  printf "$DATE_PLUS_FOURTEEN"

  if [ "$DATE_PLUS_FOURTEEN" -gt "$EXPIRE_DATE" ] && [ "$EXPIRE_DATE" -ge "$CURRENT_DATE" ]; then
    printf "$Line"
  fi
done

# ***
# Empty the file
# ***
>$File
