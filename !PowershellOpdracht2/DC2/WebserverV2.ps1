$PC_Name_DC2 = "Win02-DC2"

#Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    Install-WindowsFeature Web-Server -IncludeManagementTools
    Install-WindowsFeature Web-Basic-Auth
    restart-service w3svc

    $wwwroot_Path = "C:\inetpub\wwwroot"
    $Domain = "intranet.mijnschool.be"


    # Website 1
    # ---------
    $Web1_Name = "www"
    $Web1_Path = "$wwwroot_Path\$Web1_Name"
    $Web1_HTML = "$Web1_Path\index.html"
    $Web1_Site = "$Web1_Name.$Domain"


    # add A record in the forward lookup zones under intranet.mijnschool.be
    Add-DnsServerResourceRecordA -Name $Web1_Name -ZoneName $Domain -IPv4Address 192.168.1.3

    # Create folder structure and basic index.html file
    New-Item -Path $wwwroot_Path -Name $Web1_Name -ItemType "directory"
    Set-Content -Path $Web1_html -Value '
    <!DOCTYPE html>
    <html>
    <body style="background-color:powderblue;">
    <h1>Web1</h1>
    <p>Web1</p>
    </body>
    </html>'

    # Update hosts file
    # Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n127.0.0.1`t$Web1_Site" -Force

    # Create and start the website
    New-WebSite -Name $Web1_Name -PhysicalPath $Web1_Path -Force
    $IISSite = "IIS:\Sites\$Web1_Name"
    Set-ItemProperty $IISSite -name  Bindings -value @{protocol="http";bindingInformation="*:80:$Web1_Site"}
    Start-WebSite -Name $Web1_Name


    # Permissions
    $acl = Get-ACL -Path $Web1_Path
    $acl.SetAccessRuleProtection($True, $False) # Disable inheritance

    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow") # Add administrators with full control
    $acl.SetAccessRule($AccessRule)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM","FullControl","ContainerInherit,ObjectInherit","None","Allow")  # Add system with full control
    $acl.SetAccessRule($AccessRule)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")   # Add users with RX
    $acl.SetAccessRule($AccessRule)

    Set-Acl -Path $Web1_Path -AclObject $acl    # Commit

    set-webconfigurationproperty -filter '/system.webserver/security/authentication/anonymousauthentication' -location $Web1_Name -name enabled -value false
    set-webconfigurationproperty -filter '/system.webserver/security/authentication/basicauthentication' -location $Web1_Name -name enabled -value true


    # Website 2
    # ---------
    $Web2_Name = "Resto"
    $Web2_Path = "$wwwroot_Path\$Web2_Name"
    $Web2_HTML = "$Web2_Path\index.html"
    $Web2_Site = "$Web2_Name.$Domain"


    # add A record in the forward lookup zones under intranet.mijnschool.be
    Add-DnsServerResourceRecordA -Name $Web2_Name -ZoneName $Domain -IPv4Address 192.168.1.3

    # Create folder structure and basic index.html file
    New-Item -Path $wwwroot_Path -Name $Web2_Name -ItemType "directory"
    Set-Content -Path $Web2_HTML -Value '
    <!DOCTYPE html>
    <html>
    <body style="background-color:pink;">
    <h1>Web2</h1>
    <p>Web2</p>
    </body>
    </html>'

    # Update hosts file
    # Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "127.0.0.1`t$Web2_Site" -Force

    # Create and start the website
    New-WebSite -Name $Web2_Name -PhysicalPath $Web2_Path -Force
    $IISSite = "IIS:\Sites\$Web2_Name"
    Set-ItemProperty $IISSite -name  Bindings -value @{protocol="http";bindingInformation="*:80:$Web2_Site"}
    Start-WebSite -Name $Web2_Name

    # Permissions
    $acl = Get-ACL -Path $Web2_Path
    $acl.SetAccessRuleProtection($True, $False) # Disable inheritance

    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow") # Add administrators with full control
    $acl.SetAccessRule($AccessRule)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM","FullControl","ContainerInherit,ObjectInherit","None","Allow")  # Add system with full control
    $acl.SetAccessRule($AccessRule)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Personeel","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow")   # Add personeel with RX
    $acl.SetAccessRule($AccessRule)

    Set-Acl -Path $Web2_Path -AclObject $acl    # Commit

    set-webconfigurationproperty -filter '/system.webserver/security/authentication/anonymousauthentication' -location $Web2_Name -name enabled -value false
    set-webconfigurationproperty -filter '/system.webserver/security/authentication/basicauthentication' -location $Web2_Name -name enabled -value true

}
