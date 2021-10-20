$PC_Name = "Win02-MS"

#Connecting to Remote PS on DC2
$s = New-PSSession -ComputerName $PC_Name -Credential "INTRANET\Administrator" 

Invoke-Command -Session $s -ScriptBlock{

    # Variables
    $Share_Name = "Public"
    $Share_Path = "C:\$Share_Name"
    $File_Path = "\\Dc-1\netlogon\logon.bat"

    # Temporarily mount \\dc-1\netlogon to a letter
    # For some reason the MS can't find the logon.bat
    # This is a temporary work around
    # net use 
    # TODO
    

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

    # See if logon.bat contains "net use P: \\Win02-MS\Public"
    $Text = "This will be written to the text file"

    $SEL = Select-String -Path $File_Path -Pattern $Text

    if ($SEL -ne $null)
        {
            Write-Host "Logon.bat contains '$Text'"
        }
    else
        {
            Write-Host "Adding '$Text' to logon.bat ..."
            "net use P: \\Win02-MS\Public" | Out-File -FilePath $File_Path -Append
        }   

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