param(
    [Parameter()]
    [String]$message = "Hello World",
    [String]$emotion = "happy"
)

cd $PSScriptRoot

#------------------------------------------------------------------------------
# Testing Command line parameters
if (0 -eq 1)
{
    Write-Output $message
    Write-Output "I am $emotion"
} # End Unit Test

# $script = $PSScriptRoot + "\ReadRequest.ps1"
# & $script

#------------------------------------------------------------------------------
# Testing Math function

if (0 -eq 1)
{
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
# Get Date testing

if (0 -eq 1)
{
    echo ''
    echo "Get Date testing: "
    Get-Date -Format "dddd MM/dd/yyyy HH:mm K"
    Get-Date -Format "yyyy-MM-dd"
    echo ''
}

#------------------------------------------------------------------------------
### Displaying Local JSON files;
### Prompting the User to pick one

if (0 -eq 1)
{
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
# Testing Convert to JSON function

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
### Testing out CSV functions

if (0 -eq 1)
{
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
# Writing a saved key to a JSON file
# Create the SavedKeys file if it doesn't aleady exist.
# Add the URL JSON Property if it doesn't exist.
# Update the URL JSON Property if it does exist.

if (0 -eq 1)
{
    # also from chatgpt
    # $path = "C:\path\to\your\file.txt"
    $SavedKeysFile = "SavedKeys.json"
    $local_folder=pwd
    $local_files=""
    $SavedKeysFilePath="$($local_folder)\$($SavedKeysFile)"
    $SavedKeysFilePath

    # Check if the file exists
    if (Test-Path $SavedKeysFilePath) {
        # File exists, proceed to read it
        $SavedKeys = Get-ChildItem -Path $SavedKeysFilePath
        $content = Get-Content $SavedKeysFilePath
        Write-Output "File content:"
        Write-Output $content
        # From ChatGPT
        # Define the path to the JSON file
        # $jsonFilePath = "..\UnitTest1.json"

        # Read the existing JSON content from the file
        $jsonContent = Get-Content -Path $SavedKeysFilePath -Raw | ConvertFrom-Json

        # Define the new field and value to add
        $newField = "URL"
        $newValue = "www.outlook.com"

        if ($jsonContent.PSObject.Properties[$newField]) {
            # Property exists, update its value
            $newValue = "www.xkcd.com"
            $jsonContent.$newField = $newValue
            Write-Output "Property '$newField' updated."
            # exit(0)
        }
        else {
            # Property does not exist, add the property and value
            # $jsonObject | Add-Member -MemberType NoteProperty -Name $newField -Value $newValue

            # Add the new field to the JSON object
            $jsonContent | Add-Member -MemberType NoteProperty -Name $newField -Value $newValue
            Write-Output "Property '$newField' added."
        }



        # Convert the updated object back to JSON format
        $updatedJson = $jsonContent | ConvertTo-Json -Depth 3

        # Write the updated JSON back to the same file
        $updatedJson | Set-Content -Path $SavedKeysFilePath

        Write-Host "New field added and JSON updated successfully."
    } else {
        $note="Create a new file (if it doesn't already exist)"
        echo $note

        New-Item -Path $SavedKeysFilePath -ItemType File -Force
        $data = @{
            Note = "These are where found/saved values can be stored for multiple requests to re-access."
        }

        echo "# Write the updated JSON back to the same file"

        # Write the JSON string to the file
        $json = $data | ConvertTo-Json -Depth 2
        $json | Out-File -FilePath $SavedKeysFilePath -Encoding UTF8
        # $updatedJson | Set-Content -Path $SavedKeysFilePath
        echo "Create a file logic is done."
    }



} # End Unit Test

#------------------------------------------------------------------------------
### Writing code to leverage functions in another ps1 file.
. .\WriteSavedKey.ps1

if (1 -eq 1)
{

}
