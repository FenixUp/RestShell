### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = "Restshell_Worksheet.csv"
)

$OutputFile = ".\\outfile.txt"
$req_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

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

