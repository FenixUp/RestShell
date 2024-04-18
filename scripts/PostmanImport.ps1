### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = "001_Simple_example.json"
)


$OutputFile = ",,_Postman_import_!!.json"


### Read in the Request details from the selected input file: ##############################
clear
echo '###'
if ($TargetRequestFile -eq "")
{
    $echo = "No filename was passed to this script, please select a file with -TargetRequestFile flag."
    echo $echo
    $echo = "Exiting early."
    echo $echo
    return
}


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

# echo '### Prepare to get Iterated!'

$echo = "Request Count: " + $InputJSON.item.Count
echo $echo

for (($i = 0); $i -lt $InputJSON.item.Count; $i++)
{
    echo ''
    $echo = "### Request Number: " + ($i + 1)
    echo $echo

    $CurrentRequest = $InputJSON.item[$i]

    # Display Request Name
    $echo = "# Request Name: " + $CurrentRequest.name
    echo $echo

    # Diplay Request Method
    $echo = "# HTTP Method: " + $CurrentRequest.request.method
    echo $echo

    # Display Request Description
    # $echo = "# Request Description: " + $CurrentRequest.request.description
    # echo $echo

    # Display URL
    $echo = "# Request URL: " + $CurrentRequest.request.url.raw
    echo $echo

    # Display Request Body
    # $echo = "# Request Body: " + $CurrentRequest.request.body.raw
    # echo $echo

    # Display Headers
    for (($j = 0); $j -lt $CurrentRequest.request.header.Count; $j++)
    {
        $header = $CurrentRequest.request.header[$j]

        # $echo = "header: " + ($header.key) + ", Value: " + ([string]$header.value)
        # echo $echo
    }

}