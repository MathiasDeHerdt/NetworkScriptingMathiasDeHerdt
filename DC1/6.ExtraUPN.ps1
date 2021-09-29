Get-ADForest | Set-ADForest -UPNSuffixes @{add="mijnschool.be"}

Get-ADForest | Format-List UPNSuffixes

