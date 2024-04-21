### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = ""
)


$OutputFile = ".\,,_Postman_Import_!!.json"


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


$StartTimeNote = "### Postman Import-Start Time: " + (Get-Date).ToString()
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

$echo = "Postman Request Count: " + $InputJSON.item.Count
echo $echo

# Did i find any Postman requests in the JSON file? 
if ($InputJSON.item.Count -eq 0)
{
    echo 'Did not find any Postman requests in the selected file.'
    echo "Exiting early."
    return
}

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
        $menu_item = $menu_item - 1
        $echo = "Selecting Request: " + $InputJSON.item[$menu_item].name
        $RequestName = $InputJSON.item[$menu_item].name
        # echo $echo
        echo ''
        $finished_selection = 1
    }
}

$echo = "Selecting Request: '" + $RequestName + "' from " + $TargetRequestFile
echo $echo
$string_index = "001-"
$json_files = Get-ChildItem -Path .\*.json
$json_count = $json_files.Count + 1

# Add a leading zero if < 100
if ($json_count -lt 100)
{
    $json_count = '0' + $json_count
}
# Add another leading zero if < 10
if ($json_count -lt 10)
{ 
    $json_count = '0' + $json_count
}

# Calulate the output filename
$OutputFile = $OutputFile.Replace(',,', $json_count).Replace('!!', (Get-Date -Format "yyyy-MM-dd"))
echo $OutputFile

#return 

# assemble the JSON to push to the file.
$out_JSON = @{
    Title="--Postman Import: " + $RequestName + "--";
    TargetURL=$InputJSON.item[$menu_item].request.url.raw;
    HTTP_Method=$InputJSON.item[$menu_item].request.method;
    Headers=$InputJSON.item[$menu_item].request.header;
    Request_Body=$InputJSON.item[$menu_item].request.body.raw;
    Request_Body_FileName="";
    ReturnType="ToFile";
    Output_Filename=".\response.txt";
    EndNote="--------------------------------------------"
}

echo $out_JSON
echo ''
echo ''

$out_JSON | ConvertTo-Json -depth 4 | Out-File -FilePath $OutputFile 

# Re-open the file as a string to make some manual edits to the JSON.
$editJSON = Get-Content -Path $OutputFile -Raw
$editJSON = $editJSON.Replace('"key"', '"Name"').Replace('"value"', '"Value"').Replace("`t", "`t`t")
# .Replace('{', '{"Requests": [')
$editJSON = "{`r`t""Requests"": [`r`t" + $editJSON + "`t]`r}"
# $out_JSON = @{Requests=[$editJSON]}

# Re-Save
$editJSON | Out-File -FilePath $OutputFile 


echo 'Saved to file: ' $OutputFile