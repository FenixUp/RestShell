### Processing Input JSON ###
clear
echo '###'
echo '###'

$StartTimeNote = "### Start Time: " + (Get-Date).ToString()
$StartTimeNote

cd ~

# For local use: 
cd .\Projects\RestShell

# TODO: Need to add a way to prompt for a file name. 

# TODO: Need to add a way to Read the file name from the command line.

echo '### JSON Dump First Request'
# $InputJSON = Get-Content .\001_Simple_example.json -Raw | ConvertFrom-Json 
# $InputJSON = Get-Content .\002_Example_with_options.json -Raw | ConvertFrom-Json 
$InputJSON = Get-Content .\003_Request_Series_example.json -Raw | ConvertFrom-Json 
# $InputJSON.Requests[0]

echo '### Prepare to get Iterated!'
echo ''

# for (<Init>; <Condition>; <Repeat>)
for (($i = 0); $i -lt $InputJSON.Requests.Count; $i++)
{
    echo '### $i'
    echo $i
    $current = $InputJSON.Requests[$i]

    $TargetURL = 'URL: ' + $current.TargetURL
    $TargetURL


    $HTTP_Method = 'Method: ' + $current.HTTP_Method
    $HTTP_Method


    $Request_Body = 'Body: ' + $current.Request_Body
    $Request_Body


    $Request_Body_FileName = 'Request_Body_FileName: ' + $current.Request_Body_FileName
    $Request_Body_FileName


    $Response_Body_Output_Filename = 'Response_Body_Output_Filename: ' + $current.Response_Body_Output_Filename
    $Response_Body_Output_Filename


    $ReturnType = 'ReturnType: ' + $current.ReturnType
    $ReturnType

    echo ''
}

echo '###'
$EndTimeNote = '### Work done, zug zug - ' + (Get-Date).ToString()
$EndTimeNote
