Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$Domain = "intranet.mijnschool.be"

Install-ADDSForest -DomainName $Domain