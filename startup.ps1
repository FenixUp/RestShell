### RestShell Script ###
###
### Personal project to make a series of Rest Requests using Powershell.
### The idea being to make Rest Requests available to the layman while simplifying dev work.
###
### Open this file in Powershell ISE to leverage the other scripts in this directory
### By Default, this script will call up the command line menu that shows the different available files and scripts to run.

echo '### Moving to script folder: ' $PSScriptRoot
cd $PSScriptRoot


.\scripts\menu.ps1


### For those who hack

# If you know already know which request file to open and run, comment the menu.ps1 line, then uncomment this line with a #. Make sure to provide the filename of your JSON file
# .\scripts\InvokeRequest.ps1 -TargetRequestFile .\my_local_file.json
