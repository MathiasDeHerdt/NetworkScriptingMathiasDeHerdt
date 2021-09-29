# -Name --> de naam van de OU 
# -Path --> waar onder hij komt te staan
# DC= elk woord dat met een punt is
# intranet.mijnschool.be --> "DC=intranet,DC=mijnschool,DC=be"

# !!!
# Not needed, we import everything from the CSV file, this is just an example
# !!!
# New-ADOrganizationalUnit -Name "Mijn School" -Path "DC=intranet,DC=mijnschool,DC=be"
# 

Import-Module activedirectory

# See if the csv file exists
$csvFile = "C:\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\intranet.mijnschool.be\OUs.csv"

$TestedPath = Test-Path -Path $csvFile -PathType Leaf

echo $TestedPath

if ($TestedPath -like "False"){
    echo "Stopping the script - File not found"
    exit 1
}

# Store the data from the CSV in the $ADOU variable. 
$ADOU = Import-csv $csvFile

# Loop through each row containing user details in the CSV file
foreach ($ou in $ADou)
{
    # Read data from each field in each row and assign the data to a variable as below

    $name = $ou.Name
    $path = $ou.Path
    $desc = $ou.Description
    $display = $ou.DisplayName
    $AccidentalDel = 0

    #Account will be created in the OU provided by the $OU variable read from the CSV file
    New-ADOrganizationalUnit `
    -Name $name `
    -path $path `
    -Description $desc `
    -DisplayName $display`
    -ProtectedFromAccidentalDeletion $AccidentalDel `
}

