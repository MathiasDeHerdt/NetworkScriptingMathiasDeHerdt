$PC_Name_DC2 = "Win02-DC2"

$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    $roaming_profile_path = "\\win02-dc2\Profiles$\"

    # Get all members of the AD Group Secretariaat
    $SecrUsers = Get-ADGroupMember -Identity 'Secretariaat'

    # for every user in group secretariaat do loop through
    $SecrUsers | ForEach-Object {

        # get the username
        $SUser = (Get-ADUser $_).Name

        # make the path
        $UP = $roaming_profile_path + $SUser

        if (!(Test-Path $UP)) {
            new-item -Path $UP -ItemType Directory

            $acl = Get-ACL -Path $UP

            $acl.SetAccessRuleProtection($True, $False)

            $acl.Access | %{$acl.RemoveAccessRule($_)}

            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","Allow")
            $acl.SetAccessRule($AccessRule)

            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM","FullControl","Allow")
            $acl.SetAccessRule($AccessRule)

            $AccessRule = new-object system.security.AccessControl.FileSystemAccessRule("intranet\$SUser",'modify','Allow')
            $acl.AddAccessRule($AccessRule)

            Set-Acl -Path $UP -AclObject $acl
        }
        Set-ADUser -Identity $SUser -ProfilePath $UP    }
 }
