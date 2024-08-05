# Build script
echo '### moving to Script Folder'
cd $PSScriptRoot
$echo = '    ' +  $PSScriptRoot
$echo

$StartTimeNote = "### Start Time: " + (Get-Date).ToString()
$StartTimeNote

$BuildNumber = Read-Host '> Enter version number'
$BuildName = "Restshell_$BuildNumber"

$compress = @{
    Path = "$PSScriptRoot\scripts", "$PSScriptRoot\001_Simple_example.json", "$PSScriptRoot\002_Example_with_options.json", "$PSScriptRoot\003_Request_Series_example.json", "$PSScriptRoot\LICENSE", "$PSScriptRoot\README.md", "$PSScriptRoot\startup.ps1"
    CompressionLevel = "Optimal"
    DestinationPath = "$PSScriptRoot\$BuildName.zip"
}
Compress-Archive @compress -Force # Force overwrites

echo ''
$EndTimeNote = "### End Time: " + (Get-Date).ToString()
$EndTimeNote
echo '### Completed!'
