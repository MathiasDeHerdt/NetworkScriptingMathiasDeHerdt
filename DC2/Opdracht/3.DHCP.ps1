$PC_Name = "Win02-DC2"

#Connecting to Remote PS on DC2
$s = New-PSSession -ComputerName $PC_Name -Credential "INTRANET\Administrator" 

Invoke-Command -Session $s -ScriptBlock {
    # Variables
    $PrimaryDHCPServer = "DC-1.intranet.mijnschool.be"
    $DNS_Name2 = "Win02-DC2.intranet.mijnschool.be"
    $Scope = "192.168.1.0"
    $Pass = "P@ssw0rd"

    $IP_Family = "IPV4"
    $IP_Int_Alias = "Ethernet0"

    $IP_Address = (Get-NetIPAddress -AddressFamily $IP_Family -InterfaceAlias $IP_Int_Alias).IPAddress

    # Installing DHCP role
    Install-WindowsFeature -Name DHCP -IncludeManagementTools 

    # Configuring the DHCP Server on Dc2
    Add-DhcpServerInDC -IPAddress $IP_Address -DnsName $DNS_Name2 

    # Removing Post-Installation Warning in Server Manager
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2 

    # Creating a Failover to the DHCP Server on DC1
    Add-DhcpServerv4Failover -ComputerName $PrimaryDHCPServer -Name "SFO-SIN-Failover" -PartnerServer $DNS_Name2 -ScopeId $Scope -SharedSecret $Pass 
}