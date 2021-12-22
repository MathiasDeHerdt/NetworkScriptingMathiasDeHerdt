Write-Output "==========================================================================="
Write-Output "This script will edit the firstrun.sh on the Raspberry Pi with PowerShell"
Write-Output "==========================================================================="

# ***
# Variables
# ***
$File_Name = "firstrun.sh"
$file_Path = Read-Host "Enter the full path to the firstun.sh file (example: C:\Temp\)"
$full_Path = "$($file_Path)$($File_Name)"

# ***
# See firstrun.sh exitst in the given path
#   In my case: D:\Howest\3de\Sem1\NetworkScripting\GitHubRepo\!EXAMEN\PowershellBash\
# ***
if (Test-Path $full_Path){
    Write-Host "File exists, continuing ..."
} 
else {
    Write-Output $File_Name or $file_Path "does not exist or are not typed correctly"
    exit
}

# ***
# Create backup of firstrun.sh
# ***
Copy-Item $full_Path -Destination "C:\Temp\BackupScript\"
Write-Output "Backup complete, file location is: C:\Temp\BackupScript\"

# ***
# Edit the firstrun.sh file
# ***