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

echo "==============================================="
echo "                 Backup Script                 "
echo "==============================================="
echo ""

# See if script is running as root
if [ "$(id -u)" -ne 0 ]
then
    echo "ERROR! This script must be run by root"
    echo ""
    echo "Stopping the script ..."
    echo ""
    echo "==============================================="   
    exit 1
fi

# See if the parameters are empty or not
if [ -z "$1" ]
then
    # Stopping the script when there is no parameter
    echo "ERROR! No folder specified to backup!"
    echo "       Please specify a folder to backup"
    echo "       Example: backup.sh /etc/network/"
    echo ""
    echo "Stopping the script ..."
    echo ""
    echo "==============================================="   
    exit 2
else
    path2backup=$1
    echo "This script will make a backup of folder $path2backup"
fi

# See if the path exists
echo "Checking if the folder exists..."
if [ -d $path2backup ] 
then
    echo "    -> OK! $path2backup exists." 
else
    echo "    -> ERROR! $path2backup does not exist."
    echo "              Please specifiy an existing folder."
    echo ""
    echo "Stopping the script ..."
    echo ""
    echo "==============================================="   
    exit 3
fi

# Create the backupfolder
echo "Creating backupfolder..."
if [ -d "/BackupFolder" ] 
then
    echo "    -> Already exists" 
else
    mkdir /BackupFolder
    echo "    -> Done!" 
fi

# Backup the MySQLDatabase
echo "Backing up the MySQL Database..."
now=$(date +"%d_%m_%Y")
DBBackupFile="/BackupFolder/DBBackup-${now}.tar.gz"
DBHost="localhost"
DBPort="3306"
DBUser=""
DBPwd=""
DBName=""

mysqldump -h ${DBHost} -P ${DBPort} -u ${DBUser} -p${DBPwd} ${DBName} | gzip &gt; $DBBackupFile

if [ $? -eq 0 ]
then
    echo "    -> Done!" 
else
    echo "    -> Error!" 
    echo "Stopping the script ..."
    echo ""
    echo "==============================================="   
    exit 4
fi

# Define the backup file name and Take the backup
echo "Backing up..."
echo "    - Source: $path2backup"
now=$(date +"%d_%m_%Y")
BackupFile="/BackupFolder/Backup-${now}.tar.gz"
echo "    - Destination: $BackupFile"
tar -cvf $BackupFile $path2backup
echo "    -> Done!" 
echo "==============================================="   


