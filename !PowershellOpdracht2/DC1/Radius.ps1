$scriptPath = $MyInvocation.MyCommand.Definition
$scriptRoot = Split-Path -Path $scriptPath -Parent
$inputFile = Join-Path -Path $scriptRoot -ChildPath "RadiusClients.csv"

$RadiusClients = import-csv $inputFile -Delimiter ";"
$Secret = "MySecretH0w3sT"

ForEach ($RadiusClient in $RadiusClients){
    $FriendlyName = $($RadiusClient.FriendlyName)
    $IPAddress = $($RadiusClient.IPAddress)
    $RadiusStandard = $($RadiusClient.RadiusStd)
    
    If ($RadiusStandard -eq "") {
        Write-host "Creating new Radius Client:"
        Write-host "   - Friendly Name: $FriendlyName"
        Write-host "   - IP Address: $IPAddress"
        Write-host "   - Vandor Name: RADIUS Standard"
        New-NpsRadiusClient -Address $IPAddress -Name $FriendlyName -SharedSecret $Secret
        Write-host " -> Done!"
    }
    Else {
        Write-host "Creating new Radius Client:"
        Write-host "   - Friendly Name: $FriendlyName"
        Write-host "   - IP Address: $IPAddress"
        Write-host "   - Vandor Name: $RadiusStandard"
        New-NpsRadiusClient -Address $IPAddress -Name $FriendlyName -SharedSecret $Secret -VendorName $RadiusStandard
        Write-host " -> Done!"
    }
}
