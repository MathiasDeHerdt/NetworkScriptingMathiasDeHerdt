$PC_Name_DC2 = "Win02-DC2"

#Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    Install-WindowsFeature Web-Server -IncludeManagementTools
}

