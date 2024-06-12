### RestShell Script ###
###
### Personal project to make a series of Rest Requests using Powershell.
### The idea being to make Rest Requests available to the layman while simplifying dev work.
###
### Open this file in Powershell ISE to leverage the other scripts in this directory
### By Default, this script will call up the command line menu that shows the different available files and scripts to run.

clear
echo '### Moving to script folder: ' $PSScriptRoot
cd $PSScriptRoot


###
# If the target file is already known, or going to be the same one each time
# , enter the JSON filename in these quotes for the TargetRequestFile variable
$TargetRequestFile = ''
# $TargetRequestFile = '001_Simple_example.json'







### Implementation: ####################################################
if ($TargetRequestFile -eq '') {
    .\scripts\menu.ps1
}
else {
    .\scripts\InvokeRequest.ps1 -TargetRequestFile $TargetRequestFile
}
