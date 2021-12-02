#!/bin/bash


# This script will be running automatically
# crontab -e
#      00 17 * * 7 /Scripts/CreateBackup.sh
# 1 2 3 4 5 /path/to/script
#      1: Minutes (0-59)
#      2: Hours (0-23)
#      3: Days (1-31)
#      4: Month (1-12)
#      5: Day of the week(1-7)

printf "==============================================="
printf "                 Backup Script                 "
printf "===============================================\n\n"

# ***
# See if script is running as root
# ***

if [ "$(id -u)" -ne 0 ]
then
    printf "ERROR! This script must be run by root\n\n"
    printf "Stopping the script ...\n\n"
    printf "==============================================="
    exit 1
fi

# ***
# See if the parameters are empty or not
# ***

if [ -z "$1" ]
then
    # Stopping the script when there is no parameter
    printf "ERROR! No folder specified to backup!"
    printf "       Please specify a folder to backup"
    printf "       Example: backup.sh /etc/network/\n\n"
    printf "Stopping the script ...\n\n"
    printf "==============================================="
    exit 2
else
    path2backup=$1
    printf "This script will make a backup of folder $path2backup"
fi

# ***
# See if the path exists
# ***

printf "Checking if the folder exists..."
if [ -d $path2backup ]
then
    printf "    -> OK! $path2backup exists."
else
    printf "    -> ERROR! $path2backup does not exist."
    printf "              Please specifiy an existing folder.\n\n"
    printf "Stopping the script ...\n\n"
    printf "==============================================="
    exit 3
fi

# ***
# Create the backupfolder
# ***

printf "Creating backupfolder..."
if [ -d "/BackupFolder" ]
then
    printf "    -> Already exists"
else
    mkdir /BackupFolder
    printf "    -> Done!"
fi

# ***
# Backup the MySQLDatabase
# ***

printf "Backing up the MySQL Database..."
now=$(date +"%d_%m_%Y")
DBBackupFile="/BackupFolder/DBBackup-${now}.tar.gz"
DBHost="localhost"
DBPort="3306"
DBUser=""
DBPwd=""
DBName=""

mysqldump -h ${DBHost} -P ${DBPort} -u "${DBUser}" -p"${DBPwd}" "${DBName}" | gzip & gt; $DBBackupFile

if [ $? -eq 0 ]
then
    printf "    -> Done!"
else
    printf "    -> Error!"
    printf "Stopping the script...\n\n"
    printf "==============================================="
    exit 4
fi

# ***
# Define the backup file name and Take the backup
# ***

printf "Backing up..."
printf "    - Source: $path2backup"
now=$(date +"%d_%m_%Y")
BackupFile="/BackupFolder/Backup-${now}.tar.gz"
printf "    - Destination: $BackupFile"
tar -cvf $BackupFile $path2backup
printf "    -> Done!"
printf "==============================================="
