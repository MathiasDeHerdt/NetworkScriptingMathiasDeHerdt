$SiteName1 = "QueensTown"
$SiteNetwork1 = "192.168.1.0/24"

$SiteName2 = "Auckland"
$SiteNetwork2 = "192.168.2.0/24"

# Rename the existing site
get-ADReplicationSite "Default-First-Site-Name" | Rename-ADObject -NewName $SiteName1
New-ADReplicationSubnet -Name $SiteNetwork1 -Site $SiteName1

# Create a second site
New-ADReplicationSite -Name $SiteName2
New-ADReplicationSubnet -Name $SiteNetwork2 -Site $SiteName2