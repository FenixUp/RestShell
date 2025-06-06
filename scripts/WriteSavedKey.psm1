$DefaultLookUpFilename = ".\\LookUpValues.csv"
# $LookUpFilePath="$($local_folder)\$($LookUpFile)"

# This function creates a LookUpFile json file with a Note property explaining what the file is. 
# $lookUpFilePath should be a Full Filepath + Filename + .json
function New-LookUpFile {
    param (
        [string]$lookUpFilePath
    )
    if ($LookUpFilePath -eq "") {
        $LookUpFilePath = $DefaultLookUpFilename
    }
    if (Test-Path -Path $LookUpFilePath) {
        Write-Host "### LookUp File exists at: " $LookUpFilePath
        return
    }

    $note="### Creating a new Saved Keys file. $lookUpFilePath"
    echo $note

    New-Item -Path $lookUpFilePath -ItemType File -Force

    # Create an object with the data for the single row
    $rowData = [PSCustomObject]@{
        LookUpName = "Note"
        SearchRegex = ""
        TrimOffsetStart = 0
        TrimOffsetEnd = 0
        SavedValue = "Restshell requests can lookup values here to apply to a request and store lookup values from responses."
        IsRequired = "Optional"
    }

    # Export the object to a CSV file with a semicolon delimiter
    $rowData | Export-Csv -Path $DefaultLookUpFilename -NoTypeInformation
    
    Write-Host "### Data written to $DefaultLookUpFilename successfully."
}


# This function Saves a Key Value pair to the LookUp file. 
# If the Key already existed in the file, it gets added. 
# If not, the Key-Value gets overwritten.
# If the Lookup File doesn't exist, it gets created.
function Save-LookUpValue {
    param(
        [string]$TargetKey,
        [string]$UpdateValue,
        [string]$SearchRegex = "",
        [string]$TrimOffsetStart = 0,
        [string]$TrimOffsetEnd = 0,
        [string]$LookUpFilePath = $DefaultLookUpFilename
    )
    Write-Output "# TargetKey: $TargetKey; UpdateValue: $UpdateValue;"
    Write-Output "# LookUpFilePath: $LookUpFilePath"
    
    if ($LookUpFilePath -eq "") {
        $LookUpFilePath = $DefaultLookUpFilename
    }

    # Check if the file exists
    if (Test-Path -Path $LookUpFilePath) {
        # File exists, read the CSV content
        $csvContent = Import-Csv -Path $LookUpFilePath
        
        # Check if the key already exists
        $existingRow = $csvContent | Where-Object { $_.LookUpName -eq $TargetKey }
        
        if ($existingRow) {
            # Update existing row
            $existingRow.SavedValue = $UpdateValue
            Write-Output "# Updated existing key '$TargetKey'"
        } else {
            # Add new row
            $newRow = [PSCustomObject]@{
                LookUpName = $TargetKey
                SearchRegex = $SearchRegex
                TrimOffsetStart = $TrimOffsetStart
                TrimOffsetEnd = $TrimOffsetEnd
                SavedValue = $UpdateValue
                IsRequired = "Optional"
            }
            $csvContent = @($csvContent) + $newRow
            Write-Output "# Added new key '$TargetKey'"
        }

        # Export the updated content back to CSV
        $csvContent | Export-Csv -Path $LookUpFilePath -NoTypeInformation
        Write-Host "Data updated in $LookUpFilePath successfully."
    } else {
        # Since it doesn't exist, Create the file and then re-call this function
        CreateLookUpFile($LookUpFilePath)
        Save-LookUp-CSV($TargetKey, $UpdateValue, $LookUpFilePath)
    }
}


# This function gets the LookUp value from a CSV file.
# Returns a hashtable of LookUpName and SavedValue pairs.
function Get-LookUpValues {
    param(
        [string]$LookUpFilePath = $DefaultLookUpFilename
    )

    # Check if the file exists
    if (Test-Path -Path $LookUpFilePath) {
        Write-Output "Found LookUp file: " $LookUpFilePath
        $csvContent = Import-Csv -Path $LookUpFilePath
        
        # Create a hashtable to store the lookup values
        $lookUpValues = @{}

        # Loop through each row in the CSV
        foreach ($row in $csvContent) {
            if ($row.SavedValue.Length -lt $row.TrimOffsetStart -or $row.SavedValue.Length -lt ($row.TrimOffsetEnd + $row.TrimOffsetStart))
            {
                # If the Trim offsets are larger than the SavedValue string, default to 0s
                $row.TrimOffsetEnd = 0
                $row.TrimOffsetStart = 0
            }
            $row.SavedValue = $row.SavedValue.Substring($row.TrimOffsetStart, $row.SavedValue.Length - $row.TrimOffsetEnd - $row.TrimOffsetStart)
            Write-Output $row
            $lookUpValues[$row.LookUpName] = $row.SavedValue
        }
        
        return $lookUpValues
    } else {
        New-LookUpFile($LookUpFilePath)
        return Get-LookUpValues($LookUpFilePath)
    }
}