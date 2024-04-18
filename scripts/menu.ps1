###
### Menu.ps1
### Command Line Menu for RestShell
###


clear
echo '###'
echo '### RestShell - Make Web Requests'
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
$json_files = Get-ChildItem -Path .\*.json

$finished_selection = 0
$failure_count = 0
$json_filename = ""
$PostmanImport = 0

$RequestFromJSONMessage = "### Select a JSON file to make a web request with:"
$PostmanImportMessage = "### Select a JSON file to Import a Postman request from:"
$OptionsMessage = $RequestFromJSONMessage
while(($finished_selection -ne 1) -and ($failure_count -lt 4))
{
    echo $OptionsMessage
    echo '### Local JSON files:'
    echo "" 
    $iter = 0
    foreach( $json_file in $json_files)
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
    }
    # Did i get a number in range? 
    elseif (($menu_item -le 0) -or ($menu_item -gt $json_files.Count + 1))
    {
        $echo = '' + $menu_item + ' is out of range. Please select from the menu.'
        echo $echo
        $failure_count += 1
    }
    # Did the user select Import from Postman?
    elseif (($menu_item -eq $json_files.Count + 1) -and ($PostmanImport -eq 0))
    {
        echo ""
        echo "---"
        echo "Switching to Postman Import:"
        $PostmanImport = 1
        $OptionsMessage = $PostmanImportMessage
        echo ""
    }
    # Did the user select to return to Make Web Request?
    elseif (($menu_item -eq $json_files.Count + 1) -and ($PostmanImport -eq 1))
    {
        echo ""
        echo "---"
        echo "Switching back to Make Web Request:"
        $PostmanImport = 0
        $OptionsMessage = $RequestFromJSONMessage
        echo ""
    }
    # All set, display chosen selection, finish loop
    else
    {
        $echo = "Selecting JSON input: " + $json_files[$menu_item - 1].Name
        $json_filename = $json_files[$menu_item - 1].Name
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
    $echo = "Importing Postman requests from: " + $json_files[$menu_item - 1].Name
    echo $echo
    .\scripts\PostmanImport.ps1 -TargetRequestFile $json_filename
    return
}

### All Set, should be ok to call InvokeRequest script now.
.\scripts\InvokeRequest.ps1 -TargetRequestFile $json_filename
