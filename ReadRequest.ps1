### Processing Input JSON ###
clear
echo '###'
echo '###'

$StartTimeNote = "Start Time: " + (Get-Date).ToString()
$StartTimeNote

cd ~

# For local use: 
cd .\Projects\RestShell


$InputJSON = Get-Content .\Request_collection_001.json -Raw | ConvertFrom-Json 
$InputJSON.Requests[0]

echo '###'
$TargetURL = 'URL:' + $InputJSON.Requests.TargetURL
$TargetURL


$HTTP_Method = 'Method:' + $InputJSON.Requests.HTTP_Method
$HTTP_Method


$Request_Body = 'Body:' + $InputJSON.Requests.Request_Body
$Request_Body


$Request_Body_FileName = 'Body:' + $InputJSON.Requests.Request_Body_FileName
$Request_Body_FileName


$Response_Body_Output_Filename = 'Body:' + $InputJSON.Requests.Response_Body_Output_Filename
$Response_Body_Output_Filename



$ReturnType = 'Body:' + $InputJSON.Requests.ReturnType
$ReturnType


echo '###'
echo ''
$EndTimeNote = 'Work done, zug zug - ' + (Get-Date).ToString()
$EndTimeNote
