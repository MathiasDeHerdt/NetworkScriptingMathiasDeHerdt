$PC_Name = "Win02-MS"

#Connecting to Remote PS on DC2
$s = New-PSSession -ComputerName $PC_Name -Credential "INTRANET\Administrator" 

Invoke-Command -Session $s -ScriptBlock {

    # Variables
    $Share_Name = "Home"
    $Share_Path = "C:\$Share_Name"
       
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

    # Add Administrators with full control
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","Allow")
    $acl.SetAccessRule($AccessRule)

    # Add system with full control
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM","FullControl","Allow")
    $acl.SetAccessRule($AccessRule)

    # Add authenticated Users and give them ReadAndExecute rights
    $AccessRule = new-object system.security.AccessControl.FileSystemAccessRule('Authenticated Users','ReadAndExecute','Allow')
    $acl.AddAccessRule($AccessRule)

    # Commit everything
    Set-Acl -Path $Share_Path -AclObject $acl
}