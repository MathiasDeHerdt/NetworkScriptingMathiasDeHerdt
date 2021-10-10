# See if the csv file exists
$csvFile = "C:\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\intranet.mijnschool.be\GroupMembers.csv"

$TestedPath = Test-Path -Path $csvFile -PathType Leaf

echo $TestedPath

if ($TestedPath -like "False"){
    echo "Stopping the script - File not found"
    exit 1
}

# Store the data from the CSV in the $ADUser variable. 
$Group = Import-csv $csvFile -Delimiter ";"

# Loop through each row containing user details in the CSV file
foreach ($user in $Group)
{
    # Read data from each field in each row and assign the data to a variable as below
    $member = $user.Member
    $identity = $user.Identity


    Add-ADGroupMember `
    -Members $member `
    -Identity $identity `
}