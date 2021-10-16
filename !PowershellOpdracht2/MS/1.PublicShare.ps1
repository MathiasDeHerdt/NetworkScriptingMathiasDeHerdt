$PC_Name = "Win02-MS"

#Connecting to Remote PS on DC2
$s = New-PSSession -ComputerName $PC_Name -Credential "INTRANET\Administrator" 

Invoke-Command -Session $s -ScriptBlock{
    $File_Path = "\\Dc-1\netlogon\logon.bat"

    # See if our logon.bat exists
    if (Test-Path $File_Path){
        Write-Host "File exists"
    } 
    else {
        Write-Host "ERROR file not found"
        Write-Host "    ----> Stopping the script"
        exit 1
    }

    # Add this line to the already existing logon.bat file
    "net use P: \\Win02-MS\Public" | Out-File -FilePath $File_Path -Append
}