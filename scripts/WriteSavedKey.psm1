### Read in command line inputs: ##############################
param(
    [Parameter()]
    [String]$SavedKeysFile = "SavedKeys.json"
)

# $OutputFile = ".\\outfile.txt"
# $SavedKeysFile = ".\\SavedKeys.txt"

function Read-Value {
    param (
        [string]$Subject,
        [string]$Name
    )
}


function Save-KeyValue($TargetKey, $UpdateValue, $SavedKeysFilePath) {
   Write-Output "# TargetKey: $TargetKey; UpdateValue: $UpdateValue;"
   Write-Output "# SavedKeysFilePath: $SavedKeysFilePath"

    if ($SavedKeysFilePath -eq "") {
        $SavedKeysFilePath = ".\SavedKeys.json"
    }

    # $SavedKeysFilePath="$($local_folder)\$($SavedKeysFile)"
    # $SavedKeysFilePath

    # Check if the file exists
    if (Test-Path -Path $SavedKeysFilePath) {
        # File exists, proceed to read it
        # $SavedKeys = Get-ChildItem -Path $SavedKeysFilePath
        $content = Get-Content $SavedKeysFilePath
        Write-Output "# File content:"
        Write-Output $content
        # From ChatGPT
        # Define the path to the JSON file
        # $jsonFilePath = "..\UnitTest1.json"

        # Read the existing JSON content from the file
        $jsonContent = Get-Content -Path $SavedKeysFilePath -Raw | ConvertFrom-Json

        # Define the new field and value to add
        # $newField = "URL"
        # $newValue = "www.outlook.com"

        if ($jsonContent.PSObject.Properties[$TargetKey]) {
            # Property exists, update its value
            $jsonContent.$TargetKey = $UpdateValue
            Write-Output "# Updated Property '$TargetKey' updated."
            # exit(0)
        }
        else {
            # Property does not exist, add the property and value
            # $jsonObject | Add-Member -MemberType NoteProperty -Name $newField -Value $newValue

            # Add the new field to the JSON object
            $jsonContent | Add-Member -MemberType NoteProperty -Name $TargetKey -Value $UpdateValue
            Write-Output "# Added Property '$newField' added."
        }



        # Convert the updated object back to JSON format
        $updatedJson = $jsonContent | ConvertTo-Json -Depth 3

        # Write the updated JSON back to the same file
        $updatedJson | Set-Content -Path $SavedKeysFilePath

        Write-Host "New field added and JSON updated successfully."
    } else {
        $note="# Creating a new Saved Keys file. $SavedKeysFilePath"
        echo $note

        New-Item -Path $SavedKeysFilePath -ItemType File -Force
        $data = @{
            Note = "These are where found/saved values can be stored for multiple requests to re-access."
            $TargetKey = $UpdateValue
        }

        # echo "# Write the updated JSON back to the same file"

        # Write the JSON string to the file
        $json = $data | ConvertTo-Json -Depth 2
        $json | Out-File -FilePath $SavedKeysFilePath -Encoding UTF8
        # $updatedJson | Set-Content -Path $SavedKeysFilePath
        # echo "Create a file logic is done."
    }


}