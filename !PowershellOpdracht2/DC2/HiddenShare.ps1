$PC_Name_DC2 = "Win02-DC2"

#Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    # Variables
    $Share_Name = "Profiles$"
    $Share_Path = "C:\Profiles"

    # Make the directory we want to share
    mkdir $Share_Path

    # Share the directory, give it a name and give everyone full control
    New-SmbShare -Name $Share_Name -path $Share_Path -FullAccess Everyone

    # acl variable
    $acl = Get-ACL -Path $Share_Path

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
    $AccessRule = new-object system.security.AccessControl.FileSystemAccessRule('Authenticated Users','modify','Allow')
    $acl.AddAccessRule($AccessRule)

    # 
    # -------------------------------------------------

    # Commit everything
    Set-Acl -Path $Share_Path -AclObject $acl
}