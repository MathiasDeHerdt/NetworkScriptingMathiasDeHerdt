# See if the csv file exists
$csvFile = "C:\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\intranet.mijnschool.be\UserAccounts - Copy.csv"

$TestedPath = Test-Path -Path $csvFile -PathType Leaf

Write-Host $TestedPath

# See if the csv file exists
if ($TestedPath -like "False"){
    Write-Host "Stopping the script - File not found"
    exit 1
}

$File_Name = "logon.bat"
$File_Path = "\\Dc-1\netlogon\logon.bat"

# See if logon.bat exists, if not create it with text
if (Test-Path $File_Path){
    Write-Host "File exists, continuing ..."
} 
else {
    # When logon.bat does not exist create one and fill it with text
    New-Item -Path "\\Dc-1\netlogon\" -Name $File_Name

    # Adding the text
    "@echo off" | Out-File -FilePath $File_Path
    "net use H: \\Win02-MS\Home" | Out-File -FilePath $File_Path -Append
}

# Store the data from the CSV in the $ADUser variable. 
$ADUser = Import-csv $csvFile -Delimiter ";"

# Loop through each row containing user details in the CSV file
foreach ($user in $ADUser)
{
    Write-Host ""
    Write-Host "----------------------------------------------"
    Write-Host ""
    
    # Read data from each field in each row and assign the data to a variable as below
    $name = $user.Name
    $acc_name = $user.SamAccountName
    $given_name = $user.GivenName
    $sur_name = $user.Surname
    $display_name = $user.DisplayName
    $passwd = $user.AccountPassword
    $home_drive = $user.HomeDrive
    $home_directory = $user.HomeDirectory
    $script_path = $user.ScriptPath
    $path = $user.Path

    Write-Host ""
    Write-Host "**************************"
    Write-Host "Creatig $name"
    Write-Host "**************************"
    Write-Host ""

    # Create the users from the csv file
    New-ADUser `
    -Name $name `
    -SamAccountName $acc_name `
    -GivenName $given_name `
    -Surname $sur_name `
    -DisplayName $display_name `
    -AccountPassword (convertto-securestring "$passwd" -asplaintext -force)  `
    -HomeDrive $home_drive `
    -HomeDirectory $home_directory `
    -ScriptPath $script_path `
    -Path $path

    Write-Host ""
    Write-Host "**************************"
    Write-Host "User $name has been created!"
    Write-Host "**************************"
    Write-Host ""
}