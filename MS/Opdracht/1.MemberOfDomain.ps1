$PC_Name = "Win02-MS"

#Connecting to Remote PS on DC2
$s = New-PSSession -ComputerName $PC_Name -Credential "INTRANET\Administrator" 

Invoke-Command -Session $s -ScriptBlock{
    $Domain = "intranet.mijnschool.be"
    Add-Computer -DomainName $Domain -Restart
}

