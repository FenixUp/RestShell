### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = "001_Simple_example.json"
)

$OutputFile = ".\\outfile.txt"
$req_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

### Read in the Request details from the selected input file: ##############################
clear
echo '###'

$StartTimeNote = "### Start Time: " + (Get-Date).ToString()
$StartTimeNote

echo ''
# echo '### Moving to script folder: ' $PSScriptRoot
# cd $PSScriptRoot

echo '### Opening File:'
$TargetRequestFile = ".\" + $TargetRequestFile
$TargetRequestFile
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

    $echo = '### URL: ' + $current.TargetURL
    echo $echo
    $TargetURL = $current.TargetURL


    $echo = '### Method: ' + $current.HTTP_Method
    echo $echo
    $HTTP_Method = $current.HTTP_Method


    $Headers = ($current.Headers)
    echo ''
    $echo = "### Current Headers: " + $current.Headers
    echo $echo
    $Headers_count = $Headers.Count
    $echo = '### Headers_count: ' + $Headers_count
    echo $echo
    for ($j = 0; $j -lt $Headers_count + 0; $j++) 
    {
    <#
        $echo = '### j:' + $j
        echo $echo

        $echo = $current.Headers[$j]
        echo $echo
    #>
        $echo = $current.Headers[$j].Name + ': ' + $current.Headers[$j].Value
        echo $echo

        $req_headers.Add($current.Headers[$j].Name, $current.Headers[$j].Value)
    }


    echo ''
    $echo = '### Body: ' + $current.Request_Body
    echo $echo
    $Request_Body = $current.Request_Body


    $echo = '### Request_Body_FileName: ' + $current.Request_Body_FileName
    echo $echo
    $Request_Body_FileName = $current.Request_Body_FileName
    if ($Request_Body_FileName.Length -gt 0)
    {
        $Request_Body = Get-Content $Request_Body_FileName -Raw
    }



    $echo = '### OutputFile: ' + $current.OutputFile
    echo $echo
    $OutputFile = $current.Output_Filename

    $echo = '### ReturnType: ' + $current.ReturnType
    echo $echo
    $ReturnType = $current.ReturnType

    

    #### Rest Implementation: ###########################################################
    echo '###'
    # echo '### Starting:'
    # $StartTimeNote = "Start Time: " + (Get-Date).ToString() 
    # $StartTimeNote


    # $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    # $headers.Add("Content-Type", "application/json")
    # $headers.Add("Authorization", "Bearer " + $UnifierToken) 

    # $body = "{ ""reportname"": """+ $UDR_Name + """ }"


    echo '### Starting Request: '
    $response = ""
    if ($current.HTTP_Method -eq "GET" ) 
    {
        $response = Invoke-RestMethod $current.TargetURL -Method 'GET' -Headers $req_headers
        # $response
    }
    elseif ($current.HTTP_Method -eq "POST" ) 
    {
        $response = Invoke-RestMethod $current.TargetURL -Method 'POST' -Headers $req_headers -Body $Request_Body
        # $response
    }
    elseif ($current.HTTP_Method -eq "PUT" ) 
    {
        $response = Invoke-RestMethod $current.TargetURL -Method 'PUT' -Headers $req_headers -Body $Request_Body
        # $response
    }
    if ($current.HTTP_Method -eq "DELETE" ) 
    {
        $response = Invoke-RestMethod $current.TargetURL -Method 'DELETE' -Headers $req_headers
        # $response
    }

    echo '### Peek Response:'
    $var1 = $response.ToString().Length
    $echo = $response.ToString().Substring(0,[math]::min(100, $var1))
    echo $echo

    if ($response.ToString().Length -gt 100 )
    {
        echo ''
        echo '### Response message truncated here, please check the Output File for the full message.'
        echo ''
    }


    $response_json = $response | ConvertTo-Json -depth 5 | Out-File -FilePath $OutputFile
    # $response_json
    # | ConvertFrom-Json


    echo '### End Request'
}



echo '###'
echo ''
$EndTimeNote = "End Time: " + (Get-Date).ToString() 
$EndTimeNote
echo 'Completed!'
