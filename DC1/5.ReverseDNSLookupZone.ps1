# networkID is het subnet waar de reverse zone op komt
# forest wordt het op heel de forest gekent, bij Domain enkel op het domain

Add-DnsServerPrimaryZone -NetworkID "192.168.1.0/24" -ReplicationScope "Forest"

Get-DnsServerZone