### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = "001_Simple_example.json"
)


$OutputFile = ",,_Postman_import_!!.json"


### Read in the Request details from the selected input file: ##############################
clear
echo '###'

$StartTimeNote = "### Start Time: " + (Get-Date).ToString()
$StartTimeNote

echo '###'
echo ''
# echo '### Moving to script folder: ' $PSScriptRoot
# cd $PSScriptRoot

echo '### Opening File:'
$TargetRequestFile = ".\" + $TargetRequestFile
$TargetRequestFile
echo '' # Blank line


$InputJSON = Get-Content $TargetRequestFile -Raw | ConvertFrom-Json
