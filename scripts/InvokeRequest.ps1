### Read in command line inputs: ##############################
param(
    [Parameter()]
    [String]$TargetRequestFile = "001_Simple_example.json"
)

Import-Module -Name ".\scripts\WriteSavedKey.psm1" -Force

$OutputFile = ".\\outfile.txt"
$SavedKeysFile = ".\\SavedKeys.json"

### Read in the Request details from the selected input file: ##############################
clear
echo '###'

$StartTimeNote = "### Start Time: " + (Get-Date).ToString()
$StartTimeNote

echo '###'
echo ''
# echo '### Moving to script folder: ' $PSScriptRoot
# cd $PSScriptRoot

$TargetRequestFile = ".\" + $TargetRequestFile
echo "### Opening File: $TargetRequestFile"
echo '' # Blank line


$InputJSON = Get-Content $TargetRequestFile -Raw | ConvertFrom-Json

# echo '### Prepare to get Iterated!'

# for (<Init>; <Condition>; <Repeat>)
for (($i = 0); $i -lt $InputJSON.Requests.Count; $i++)
{
    echo ''
    $echo = "### Request Number: " + ($i + 1)
    $echo

    $current = $InputJSON.Requests[$i]

    $TargetURL = $current.TargetURL
    $LookUpValues = Get-LookUpValues
    foreach($LookUp in $LookUpValues) {
        $LookUpName = "{" + $LookUp.LookUpName + "}"
        $TargetURL = $TargetURL -creplace $LookUpName,$LookUp.SavedValue
    }
    $echo = '### URL: ' + $TargetURL
    echo $echo

    $echo = '### Method: ' + $current.HTTP_Method
    echo $echo
    $HTTP_Method = $current.HTTP_Method

    $req_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

    $Headers = ($current.Headers)
    echo ''
    $echo = "### Current Headers: " + $current.Headers
    echo $echo
    $Headers_count = $Headers.Count
    $echo = '### Headers_count: ' + $Headers_count
    echo $echo
    for ($j = 0; $j -lt $Headers_count + 0; $j++) 
    {
        $header_value = $current.Headers[$j].Value
        foreach($LookUp in $LookUpValues) {
            $LookUpName = "{" + $LookUp.LookUpName + "}"
            $header_value = $header_value -creplace $LookUpName,$LookUp.SavedValue
        }
        $echo = $current.Headers[$j].Name + ': ' + $header_value
        echo $echo

        $req_headers.Add($current.Headers[$j].Name, $header_value)
    }


    echo ''
    $echo = '### Body: ' + $current.Request_Body
    echo $echo
    $Request_Body = $current.Request_Body


    $Request_Body_FileName = $current.Request_Body_FileName
    if ($Request_Body_FileName.Length -gt 0)
    {
        $echo = '### Request_Body_FileName: ' + $current.Request_Body_FileName
        echo $echo
        $Request_Body = Get-Content $Request_Body_FileName -Raw
        $Request_Body_FileName = $current.Request_Body_FileName
    }


    $OutputFile = $current.Output_Filename
    $echo = '### OutputFile: ' + $OutputFile

    if ($current.ReturnType.Length -eq 0){
        echo '### ReturnType: None'
    }
    else {
        $echo = '### ReturnType: ' + $current.ReturnType
        echo $echo
    }
    $ReturnType = $current.ReturnType


    #### Rest Implementation: ###########################################################
    echo '###'

    $StartTimeNote = "### Starting Request: " + (Get-Date).ToString()
    $StartTimeNote

    ## Beginning Pre-Processing.
    ## Applying Saved Key-Values to the request before sending.
    

    $response = ""
    try
    {
        if ($current.HTTP_Method -eq "GET" -or $current.HTTP_Method -eq "DELETE") 
        {
            $response = Invoke-WebRequest $TargetURL -Method $current.HTTP_Method -Headers $req_headers
            $StatusCode = $Response.StatusCode
            $StatusDescription = $Response.StatusDescription
        }
        elseif ($current.HTTP_Method -eq "POST" -or $current.HTTP_Method -eq "PUT")
        {
            $response = Invoke-WebRequest $TargetURL -Method $current.HTTP_Method -Headers $req_headers -Body $Request_Body
            $StatusCode = $Response.StatusCode
            $StatusDescription = $Response.StatusDescription
        }
    }
    catch
    {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        # $StatusDescription = $_.Exception.Response.StatusDescription.value__
        $StatusDescription = 'HTTP Exception Code'
        echo '###'
        $echo = '### HTTP Status Code: ' + $StatusCode + ' - ' + $StatusDescription + ' - ' + (Get-Date).ToString()
        echo $echo
        echo '###'
        echo '###'
        echo '### Web Exception Encountered - Ending Request Processing'
        return
    }


    echo '###'
    $echo = '### HTTP Status Code: ' + $StatusCode + ' - ' + $StatusDescription + ' - ' + (Get-Date).ToString()
    echo $echo
    $peek_limit = 200
    $echo = '### Peek Response: (top ' + $peek_limit + ' characters)' 
    echo $echo
    echo '---'

    $response_payload = ""

    if ($ReturnType -eq "JSON")
    {
        $response_payload = $response | Convert-To -depth 5 | Out-String
    }
    else
    {
        $response_payload = $response.RawContent.ToString()
        $LookUpValues = Get-LookUpValues
        foreach($LookUp in $LookUpValues) {
            if ($LookUp.SearchRegex.Length -gt 0){
                $regexPattern = $LookUp.SearchRegex
                $regex_match = [regex]::Match($response_payload, $regexPattern).Value
                Save-LookUpValue $LookUp.LookUpName $regex_match
            }
        }
    }

    $echo = $response_payload.Substring(0,[math]::min($peek_limit, $response_payload.Length))
    echo $echo

    if ($response_payload.Length -gt $peek_limit)
    {
        echo '---'
        echo '### Response message truncated here, please check the Output File for the full message.'
        echo ''
    }


    if ($current.ReturnType -eq "JSON") {
        $response_payload -replace "`r`n", "`n" | Out-File -FilePath $OutputFile
    }
    else {
        $response | Out-File -FilePath $OutputFile
    }

    # Request Post-Processing
    # Collecting Key-Values from request and searching the response info.
    Write-Output "### Collecting Key-Values from request and searching the response info."
    # Save-KeyValue "RunnerA" "First-Base" $SavedKeysFile


    echo ''
    echo '### End Request'
}


echo '###'
echo ''
$EndTimeNote = "End Time: " + (Get-Date).ToString() 
$EndTimeNote
echo 'Completed!'
