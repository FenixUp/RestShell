###
### Menu.ps1
### Command Line Menu for RestShell.
###



clear
echo '###'
echo '### RestShell - Make Web Requests'
echo '###'
echo '### Moving to script folder'
echo $PSScriptRoot
echo '###'
echo ''
cd $PSScriptRoot


### Displaying Local JSON files;
### Prompting the User to pick one
echo '###'
# Get-ChildItem -Path .\*.json
$json_files = Get-ChildItem -Path .\*.json

$finished_selection = 0
$failure_count = 0
$json_filename = ""
while(($finished_selection -ne 1) -and ($failure_count -lt 4))
{
    echo 'Local JSON files:'
    $iter = 0
    foreach( $json_file in $json_files)
    {
        $iter += 1
        $echo = '' + $iter + ': ' + $json_file.Name
        echo $echo
    }
    echo '(q)uit to exit: '

    $menu_item = 0
    $menu_item = Read-Host 'Select a JSON file by number'

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
    elseif (($menu_item -le 0) -or ($menu_item -gt $json_files.Count))
    {
        $echo = '' + $menu_item + ' is out of range. Please select from the menu.'
        echo $echo
        $failure_count += 1
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

### All Set, should be ok to call InvokeRequest script now.
.\InvokeRequest.ps1 -TargetRequestFile $json_filename
