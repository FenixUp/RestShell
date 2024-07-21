### Read in command line inputs: ##############################

param(
    [Parameter()]
    [String]$TargetRequestFile = "Restshell_Worksheet.csv"
)

$OutputFile = ".\\outfile.txt"
$req_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

### Read in the Request details from the selected input file: ##############################
clear
echo '###'

$StartTimeNote = "### Start Time: " + (Get-Date).ToString()
$StartTimeNote

echo '###'
echo ''
# echo '### Moving to script folder: ' $PSScriptRoot
# cd $PSScriptRoot

echo '### Opening File:'
$TargetRequestFile = ".\" + $TargetRequestFile
$TargetRequestFile
echo '' # Blank line


$csv_data = Import-Csv -Delimiter "," -Path $TargetRequestFile
# Write-Output $csv_data
$csv_data[0].psobject.properties.name[0]

### For Loop methodology: ##############################
    ### Retrieve CSV values
    ### Save CSV request as RestShell JSON
    ### Submit to InvokeRequest as a typical RestShell JSON request
# echo '### Prepare to get Iterated!'
# for (<Init>; <Condition>; <Repeat>)
for (($i = 0); $i -lt $csv_data.Count; $i++)
{
    ### Retrieving CSV values:
    $RequestTitle = ""
    $RequestURL = ""
    $HTTP_Method = ""
    $Headers = ""
    $Request_Body = ""
    $Request_Body_FileName = ""
    $Request_Output_Filename = ""

    echo ''
    $echo = "### Request Number: " + ($i + 1)
    $echo

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Request Title")
    $RequestTitle = $csv_data[$i].psobject.properties.value[$ndx]

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Target URL")
    $RequestURL = $csv_data[$i].psobject.properties.value[$ndx]

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Http_Method")
    $HTTP_Method = $csv_data[$i].psobject.properties.value[$ndx]

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Headers")
    $Headers = $csv_data[$i].psobject.properties.value[$ndx]

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Request_Body")
    $Request_Body = $csv_data[$i].psobject.properties.value[$ndx]

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Request_Body_FileName")
    $Request_Body_FileName = $csv_data[$i].psobject.properties.value[$ndx]

    $ndx = [array]::IndexOf($csv_data[0].psobject.properties.name, "Output_Filename")
    $Request_Output_Filename = $csv_data[$i].psobject.properties.value[$ndx]


    ### Saving CSV request as RestShell JSON
    $json_files = Get-ChildItem -Path .\*.json
    $json_count = $json_files.Count + 1

    # Add a leading zero if < 100
    if ($json_count -lt 100)
    {
        $json_count = '0' + $json_count
    }
    # Add another leading zero if < 10
    if ($json_count -lt 10)
    {
        $json_count = '0' + $json_count
    }

    # Calulate the output filename
    $OutputFile = ".\,,_CSV_Import_!!.json"
    $OutputFile = $OutputFile.Replace(',,', $json_count).Replace('!!', (Get-Date -Format "yyyy-MM-dd"))
    echo $OutputFile

    # return

    # assemble the JSON to push to the file.
    $out_JSON = @{
        Title=$RequestTitle
        TargetURL=$RequestURL
        HTTP_Method=$HTTP_Method
        Headers=$Headers
        Request_Body=$Request_Body
        Request_Body_FileName=$Request_Body_FileName
        ReturnType="ToFile";
        Output_Filename=".\response.txt";
        EndNote="--------------------------------------------"
    }

    $out_JSON | ConvertTo-Json -depth 4 | Out-File -FilePath $OutputFile

    # Re-open the file as a string to make some manual edits to the JSON.
    $editJSON = Get-Content -Path $OutputFile -Raw
    $editJSON = $editJSON.Replace('"key"', '"Name"').Replace('"value"', '"Value"').Replace("`t", "`t`t")
    # .Replace('{', '{"Requests": [')
    $editJSON = "{`r`t""Requests"": [`r`t" + $editJSON + "`t]`r}"
    # $out_JSON = @{Requests=[$editJSON]}
    $editJSON = $editJSON.Replace('"Headers":  "', '"Headers": ').Replace('}]",', '}],').Replace("`t", "`t`t")
    # .Replace('{', '{"Requests": [')
    $editJSON = "{`r`t""Requests"": [`r`t" + $editJSON + "`t]`r}"

    # Re-Save
    $editJSON | Out-File -FilePath $OutputFile

    echo 'Saved to file: ' $OutputFile

    ### Submit to InvokeRequest as a typical RestShell JSON request
    ### All Set, should be ok to call InvokeRequest script now.
    # .\scripts\InvokeRequest.ps1 -TargetRequestFile $json_filename


    echo '### End Request'
} # End For
