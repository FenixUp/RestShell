### TODO: Read from a target file. 








#### Rest Implementation: ###########################################################
echo '###'
echo '###'
$StartTimeNote = "Start Time: " + (Get-Date).ToString() 
$StartTimeNote


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", "Bearer " + $UnifierToken) 


$body = "{ ""reportname"": """+ $UDR_Name + """ }"


echo 'Starting Request: '
$response = Invoke-RestMethod $UnifierURL -Method 'POST' -Headers $headers -Body $body
$response


$response_json = $response | ConvertTo-Json  -depth 5 | Out-File -FilePath $OutputFile
$response_json
# | ConvertFrom-Json



echo '###'
$EndTimeNote = "End Time: " + (Get-Date).ToString() 
$EndTimeNote
echo 'Completed!'
