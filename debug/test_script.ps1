param(
    [Parameter()]
    [String]$message = "Hello World",
    [String]$emotion = "happy"
)

cd $PSScriptRoot

if (0 -eq 1)
{
    # Testing Command line parameters
    Write-Output $message
    Write-Output "I am $emotion"
} # End Unit Test

# $script = $PSScriptRoot + "\ReadRequest.ps1"
# & $script

#------------------------------------------------------------------------------

if (0 -eq 1)
{

    # Testing Math function

$var1 = 10
# [math]::min($var1,$var2)
$echo = [math]::min(100, $var1)
$echo

$var1 = 111
# [math]::min($var1,$var2)
$echo = [math]::min(100, $var1)
$echo

} # End Unit Test

#------------------------------------------------------------------------------

if (0 -eq 1)
{
    # Get Date testing
    echo ''
    echo "Get Date testing: "
    Get-Date -Format "dddd MM/dd/yyyy HH:mm K"
    Get-Date -Format "yyyy-MM-dd"
    echo ''
}

#------------------------------------------------------------------------------

if (0 -eq 1)
{
### Displaying Local JSON files;
### Prompting the User to pick one
# Get-ChildItem -Path .\*.json
$json_files = Get-ChildItem -Path .\*.json

echo 'Viewing list of JSON files:'
$iter = 0
foreach( $json_file in $json_files)
{
    $iter += 1
    # echo $json_file.FullName
    $echo = '' + $iter + ': ' + $json_file.Name
    echo $echo
}

} # End Unit Test

#------------------------------------------------------------------------------

if (0 -eq 1)
{
# $menu_item = Read-Host 'Select a JSON file by number'

# $echo = "You have selected: " + $json_files[$menu_item - 1].Name
# echo $echo


# while($val -ne 3)
# {
    # $val++
    # Write-Host $val
# }


$menu_item -match '^[0-9]+$'



$restshell_json = @{
    Title="--Postman Import: " + $RequestName + "--";
    # TargetURL=$InputJSON.item[$menu_item].request.url.raw;
    # HTTP_Method=$InputJSON.item[$menu_item].request.method;
    # Request_Body=$InputJSON.item[$menu_item].request.body.raw;
    Request_Body_FileName="";
    ReturnType="ToFile";
    Output_Filename=".\\response.txt";
    zEndNote="--------------------------------------------"
}

$restshell_json | ConvertTo-Json -depth 4

} # End Unit Test

#------------------------------------------------------------------------------

if (1 -eq 1)
{
    ### Testing out CSV functions

    $csv_data = Import-Csv -Delimiter "," -Path "..\\Restshell_Worksheet.csv"
    # Write-Output $csv_data
    $csv_data[0].psobject.properties.name[0]

    # get header index
    $array = 'A','B','C'
    $item = 'B'
    $ndx = [array]::IndexOf($array, $item)
    echo "Function Test:" $ndx

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Request Title")
    echo "Request Title:" $ndx
    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Request_Body")
    echo "Request_Body:" $ndx

    # get cell value!
    $csv_data[1].psobject.properties.value[$ndx]



} # End Unit Test

#------------------------------------------------------------------------------

