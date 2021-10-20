$PC_Name_DC2 = "Win02-DC2"
$PC_Name_MS = "Win02-MS"

#Connecting to Remote PS on DC2
$S_DC2 = New-PSSession -ComputerName $PC_Name_DC2 -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_DC2 -ScriptBlock {
    $File_Path = "\\Dc-1\netlogon\logon.bat"
    $Text = "net use P: \\MS\Public"

    # See if our logon.bat exists
    if (Test-Path $File_Path){
        Write-Host "File exists, continuing ..."
    } 
    else {
        # when logon.bat does not exist stop the script
        Write-Host "ERROR file not found"
        Write-Host "    ----> Stopping the script"
        exit 1
    }

    # Add text to logon.bat
    $SEL = Select-String -Path $File_Path -Pattern $Text

    if ($SEL -ne $null)
        {
            Write-Host "Login.bat contains '$Text'"
        }
    else
        {
            Write-Host "Adding '$Text' to login.bat ..."
            Add-Content $File_Path "`nnet use P: \\Win02-MS\Public"
        }
}


$S_MS = New-PSSession -ComputerName $PC_Name_MS -Credential "INTRANET\Administrator"

Invoke-Command -Session $S_MS -ScriptBlock {
        # Variables
        $Share_Name = "Public"
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
        $AccessRule = new-object system.security.AccessControl.FileSystemAccessRule('Personeel','modify','Allow')
        $acl.AddAccessRule($AccessRule)
    
        # 
        # -------------------------------------------------
    
        # Commit everything
        Set-Acl -Path $Share_Path -AclObject $acl
}
