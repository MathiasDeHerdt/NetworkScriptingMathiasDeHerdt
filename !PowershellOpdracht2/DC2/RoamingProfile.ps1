$PC_Name_DC2 = "Win02-DC2"

# Read all the names in Secretariaat and write them in a csv file
Get-ADGroupMember -Identity 'Secretariaat' -Recursive | select name | Export-csv -path '\\dc-1\C$\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\!PowershellOpdracht2\sec.csv' -Notypeinformation

# Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    $csv_file_path = "\\DC-1\c`$\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\!PowershellOpdracht2\sec.csv"
    $roaming_profile_path = "\\win02-dc2\Profiles\%username%"

    # See if we can find the csv file
    if (Test-Path $csv_file_path){
        Write-Host "File exists, continuing ..."
    } 
    else {
        # when logon.bat does not exist stop the script
        Write-Host "ERROR file not found"
        Write-Host "    ----> Stopping the script"
        exit 1
    }
   
    $ADOU = Import-csv $csv_file_path -Delimiter ";"

    # Loop through all the names in the csv file
    foreach ($ou in $ADou) {
        $ProfileName = $ou.name

        Write-Host ""
        Write-Host "Making a reaming profile for: $ProfileName"
        Set-ADUser -Identity $ProfileName -ProfilePath $roaming_profile_path
        Write-Host ""
    }
}
