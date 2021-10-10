# See if the csv file exists
$csvFile = "C:\Mathias\GitHubRepoV2\NetworkScriptingMathiasDeHerdt\intranet.mijnschool.be\groups.csv"

$TestedPath = Test-Path -Path $csvFile -PathType Leaf

echo $TestedPath

if ($TestedPath -like "False"){
    echo "Stopping the script - File not found"
    exit 1
}

# Store the data from the CSV in the $ADUser variable. 
$Groups = Import-csv $csvFile -Delimiter ";"

# Loop through each row containing user details in the CSV file
foreach ($Group in $Groups)
{
    # Read data from each field in each row and assign the data to a variable as below
    $path = $Group.Path
    $name = $Group.Name
    $display_name = $Group.DisplayName
    $desc = $Group.Description
    $category = $Group.GroupCategory
    $scope = $Group.GroupScope

    New-ADGroup `
    -Path $path `
    -Name $name `
    -DisplayName $display_name `
    -Description $desc `
    -GroupCategory $category `
    -GroupScope $scope
}