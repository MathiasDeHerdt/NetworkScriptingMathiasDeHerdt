$PC_Name_DC2 = "Win02-DC2"

#Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    # Install-WindowsFeature Web-Server -IncludeManagementTools

    $Path_wwwroot = "C:\inetpub\wwwroot"

    $path_resto = "$Path_wwwroot\resto"
    $path_www = "$Path_wwwroot\www"

    $path_www_html = "$path_www\index.html"
    $path_resto_html = "$path_resto\index.html"
    
    # 
    # resto.intranet.mijnschool.be HTML FILE
    # 
    New-Item -Path $Path_wwwroot -Name "resto" -ItemType "directory"
    New-Item -Path $path_resto -Name "index.html" -ItemType "file"
    
    Set-Content -Path $path_resto_html -Value '
    <!DOCTYPE html>
    <html>
    <body style="background-color:powderblue;">
    
    <h1>RESTO</h1>
    <p>This is a paragraph.</p>
    
    </body>
    </html>'

    # 
    # www.intranet.mijnschool.be HTML FILE
    # 

    New-Item -Path $Path_wwwroot -Name "www" -ItemType "directory"
    New-Item -Path $path_www -Name "index.html" -ItemType "file"
    
    Set-Content -Path $path_www_html -Value '
    <!DOCTYPE html>
    <html>
    <body style="background-color:pink;">
    
    <h1>WWW</h1>
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

    # Create www website
    New-WebSite -Name $CNAME_www -PhysicalPath $path_www -Force
    $IISSite = "IIS:\Sites\$CNAME_www"
    Set-ItemProperty $IISSite -name  Bindings -value @{protocol="http";bindingInformation="*:80:$FQDN_www"}
    
    Write-Host "`nCreated website $CNAME_www"
    Write-Host "Viste the site on: $FQDN_www"

    # Create resto website
    New-WebSite -Name $CNAME_resto -PhysicalPath $path_resto -Force
    $IISSite2 = "IIS:\Sites\$CNAME_resto"
    Set-ItemProperty $IISSite2 -name  Bindings -value @{protocol="http";bindingInformation="*:80:$FQDN_resto"}
    
    Write-Host "`nCreated website $CNAME_resto"
    Write-Host "Viste the site on: $FQDN_resto"

    # Start the websites
    Start-WebSite -Name $CNAME_resto
    Write-Host "`nStarted website $CNAME_resto"

    Start-WebSite -Name $CNAME_www
    Write-Host "`nStarted website $CNAME_www"
    
    #
    # Set permissions on www.intranet.mijnschool.be
    #

    # acl variable
    $acl = Get-ACL -Path $path_www

    # Disable inheritance
    $acl.SetAccessRuleProtection($True, $False)
    
    # Remove everyone from folder
    $acl.Access | %{$acl.RemoveAccessRule($_)}

    # -------------------------------------------------
    # *********************************************
    # Adding groups to share with ntfs permissions
    # *********************************************

    # Add administrators with full control
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","Allow")
    $acl.SetAccessRule($AccessRule)

    # Add system with full control
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM","FullControl","Allow")
    $acl.SetAccessRule($AccessRule)

    # Add Personeel Users and give them ReadAndExecute rights
    $AccessRule = new-object system.security.AccessControl.FileSystemAccessRule('Personeel','ReadAndExecute','Allow')
    $acl.AddAccessRule($AccessRule)

    # 
    # -------------------------------------------------

    # Commit everything
    Set-Acl -Path $path_www -AclObject $acl
}

