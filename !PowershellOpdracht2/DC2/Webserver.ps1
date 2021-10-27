$PC_Name_DC2 = "Win02-DC2"

#Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    # Install-WindowsFeature Web-Server -IncludeManagementTools

    $Path_wwwroot = "C:\inetpub\wwwroot"
    $path_resto = "$Path_wwwroot\resto"
    $path_resto_html = "$path_resto\index.html"
    $path_wwwroot_html = "C:\inetpub\wwwroot\index.html"
    
    # 
    # resto.intranet.mijnschool.be HTML FILE
    # 
    New-Item -Path $Path_wwwroot -Name "resto" -ItemType "directory"
    New-Item -Path $path_resto -Name "index.html" -ItemType "file"
    
    Set-Content -Path $path_resto_html -Value '
    <!DOCTYPE html>
    <html>
    <body style="background-color:powderblue;">
    
    <h1>This is a heading</h1>
    <p>This is a paragraph.</p>
    
    </body>
    </html>'

    # 
    # www.intranet.mijnschool.be HTML FILE
    # 

    New-Item -Path $Path_wwwroot -Name "index.html" -ItemType "file"
    
    Set-Content -Path $path_wwwroot_html -Value '
    <!DOCTYPE html>
    <html>
    <body style="background-color:pink;">
    
    <h1>This is a heading</h1>
    <p>This is a paragraph.</p>
    
    </body>
    </html>'

    # DNS ALIAS CNAME RECORD
    
    $CNAME_www = "www"
    $CNAME_resto = "resto"

    $FQDN_www = "www.intranet.mijnschool.be"
    $FQDN_resto = "resto.intranet.mijnschool.be"

    $DNS_Zone = "intranet.mijnschool.be"

    # add "www" cname record in the forward lookup zones under intranet.mijnschool.be
    Add-DnsServerResourceRecordCName -Name $CNAME_www -HostNameAlias $FQDN_www -ZoneName $DNS_Zone

    # # add "resto" cname record in the forward lookup zones under intranet.mijnschool.be
    Add-DnsServerResourceRecordCName -Name $CNAME_resto -HostNameAlias $FQDN_resto -ZoneName $DNS_Zone
}

