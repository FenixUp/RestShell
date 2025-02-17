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


function Save-Value($SavedKeysFile, $TargetKey, $UpdateValue) {
   Write-Output "TargetKey: $TargetKey; UpdateValue: $UpdateValue; SavedKeysFile: $SavedKeysFile"
}