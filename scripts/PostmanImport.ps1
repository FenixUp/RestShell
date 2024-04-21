### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = ""
)


$OutputFile = ",,_Postman_import_!!.json"


### Read in the Request details from the selected input file: ##############################
# clear
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

$finished_selection = 0
$failure_count = 0
while(($finished_selection -ne 1) -and ($failure_count -lt 4))
{
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
        $Display_length = 70
        if ($CurrentRequest.request.url.raw.Length -gt $Display_length)
        {
            $echo = "# Request URL: " + $CurrentRequest.request.url.raw.substring(0, $Display_length) + '...'
        }
        else 
        {
            $echo = "# Request URL: " + $CurrentRequest.request.url.raw
        }
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
    if ($failure_count -ge 4)
    {
        echo 'Too many failed inputs, exiting early'
        return
    }

    echo ''
    echo ' (q)uit to exit: '

    $menu_item = 0
    $menu_item = Read-Host '> Select a JSON file by number'

    # Did the user send a quit message? 
    if (($menu_item -eq 'q') -or ($menu_item -eq 'quit'))
    {
        echo 'Exiting early.'
        return
    }
    # Did i get a valid number? 
    elseif (-not ($menu_item -match '^[0-9]+$'))
    {
        echo 'Please enter a valid number.'
        $failure_count += 1
        $menu_item = Read-Host '> (Press Enter)'
    }
    # Did i get a number in range? 
    elseif (([int]$menu_item -le 0) -or ([int]$menu_item -gt $InputJSON.item.Count))
    {
        $echo = '' + $menu_item + ' is out of range. Please select from the menu. ' + $InputJSON.item.Count
        echo $echo
        $failure_count += 1
        $menu_item = Read-Host '> (Press Enter)'
    }
    # All set, display chosen selection, finish loop
    else
    {
        $echo = "Selecting Request: " + $InputJSON.item[$menu_item].name
        $RequestName = $InputJSON.item[$menu_item].name
        # echo $echo
        echo ''
        $finished_selection = 1
    }
}

$echo = "Selecting Request: '" + $RequestName + "' from " + $TargetRequestFile
echo $echo