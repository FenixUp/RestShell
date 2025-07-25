###
### Menu.ps1
### Command Line Menu for RestShell
###


clear
echo '###'
echo '### RestShell - Make Web Requests - 1.3.1'
echo '###'
# echo '### Moving to script folder'
# echo $PSScriptRoot
# cd $PSScriptRoot
# echo '###'
echo ''


### Displaying Local JSON files;
### Prompting the User to pick one
# echo '###'
# Get-ChildItem -Path .\*.json
$local_files = Get-ChildItem -Path .\*.json

$finished_selection = 0
$failure_count = 0
$json_filename = ""
$PostmanImport = 0
$CsvImport = 0

$RequestFromJSONMessage = "### Select a JSON file to make a web request with:"
$PostmanImportMessage = "### Select a JSON file to Import a Postman request from:"
$CsvImportMessage = "### Select a CSV file to Import a request from:"
$OptionsMessage = $RequestFromJSONMessage
while(($finished_selection -ne 1) -and ($failure_count -lt 4))
{
    echo $OptionsMessage
    echo '### Local JSON files:'
    echo "" 
    $iter = 0
    # Display the local files
    foreach( $json_file in $local_files)
    {
        $iter += 1
        $echo = '' + $iter + ': ' + $json_file.Name
        echo $echo
    }
    echo ""
    echo "### Other options: "
    $iter += 1
    if ($PostmanImport -eq 0)
    {
        $echo = ' ' + $iter + ": " + "Import from Postman Export"
    }
    elseif ($PostmanImport -eq 1) 
    {
        $echo = ' ' + $iter + ": " + "Back to Make Web Request"
    }
    echo $echo

    $iter += 1
    if ($CsvImport -eq 0)
    {
        $echo = ' ' + $iter + ": " + "Import from CSV Request"
    }
    elseif (($CsvImport -eq 1) -and ($PostmanImport -eq 0))
    {
        $echo = ' ' + $iter + ": " + "Back to Make Web Request"
    }
    echo $echo
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
    elseif (([int]$menu_item -le 0) -or ([int]$menu_item -gt $local_files.Count + 2))
    {
        $echo = '' + $menu_item + ' is out of range. Please select from the menu.'
        echo $echo
        $failure_count += 1
        $menu_item = Read-Host '> (Press Enter)'
    }
    # Did the user select Import from Postman?
    elseif (([int]$menu_item -eq $local_files.Count + 1) -and ($PostmanImport -eq 0))
    {
        echo ""
        echo "---"
        echo "Switching to Postman Import:"
        $PostmanImport = 1
        $OptionsMessage = $PostmanImportMessage
        echo ""
    }
    # Did the user select CSV Import?
    elseif (([int]$menu_item -eq $local_files.Count + 2) -and ($CsvImport -eq 0))
    {
        echo ""
        echo "---"
        echo "Switching to CSV Import:"
        $local_files = Get-ChildItem -Path .\*.csv
        $CsvImport = 1
        $OptionsMessage = $CsvImportMessage
        echo ""
    }
    # Did the user select to return to Make Web Request?
    elseif ( (([int]$menu_item -eq $local_files.Count + 1) -and ($PostmanImport -eq 1)) -or (([int]$menu_item -eq $local_files.Count + 2) -and ($CsvImport -eq 1)))
    {
        echo ""
        echo "---"
        echo "Switching back to Make Web Request:"
        $local_files = Get-ChildItem -Path .\*.json
        $PostmanImport = 0
        $CsvImport = 0
        $OptionsMessage = $RequestFromJSONMessage
        echo ""
    }
    # All set, display chosen selection, finish loop
    else
    {
        $echo = "Selecting JSON input: " + $local_files[$menu_item - 1].Name
        $json_filename = $local_files[$menu_item - 1].Name
        echo $echo
        $finished_selection = 1
    }
}

if ($failure_count -ge 4)
{
    echo 'Too many failed inputs, exiting early'
    return
}

# Switching to Postman Import if flag was raised in Menu
if ($PostmanImport -eq 1)
{
    $echo = "Importing Postman requests from: " + $local_files[$menu_item - 1].Name
    echo $echo
    .\scripts\PostmanImport.ps1 -TargetRequestFile $json_filename
    return
}
elseif ($CsvImport -eq 1)
{
    $echo = "Importing Csv requests from: " + $local_files[$menu_item - 1].Name
    echo $echo
    .\scripts\CsvRequest.ps1 -TargetRequestFile $json_filename
    return
}

### All Set, should be ok to call InvokeRequest script now.
.\scripts\InvokeRequest.ps1 -TargetRequestFile $json_filename
