# See if the csv file exists
$csvFile = "C:\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\intranet.mijnschool.be\UserAccounts - Copy.csv"

$TestedPath = Test-Path -Path $csvFile -PathType Leaf

Write-Host $TestedPath

if ($TestedPath -like "False"){
    Write-Host "Stopping the script - File not found"
    exit 1
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