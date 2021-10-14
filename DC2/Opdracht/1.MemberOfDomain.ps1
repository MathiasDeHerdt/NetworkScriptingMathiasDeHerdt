$Computer_Name = "Win02-DC2"

# Run script on remote machine
Invoke-Command -ComputerName $Computer_Name {
    $Domain = "intranet.mijnschool.be"

    Write-Host "Adding machine to domain $Domain"
    Add-Computer -DomainName $Domain -Restart
}

