Param (
 [Parameter(Mandatory=$true)][string]$Token,
 [Parameter(Mandatory=$true)][string]$CaseId,
 [Parameter(Mandatory=$true)][string]$VolWebEndpointURL,
 [Parameter(Mandatory=$true)][string]$BucketEndpointURL,
 [Parameter(Mandatory=$true)][string]$BucketEndpointId,
 [Parameter(Mandatory=$true)][string]$BucketEndpointKey,
 [Parameter(Mandatory=$true)][string]$MemoryDumpsPath,
 [Parameter(Mandatory=$false)][bool]$UseSSL=$true
)

$Headers = @{
    "Authorization" = "Token " + $Token;
}

$CaseUri = $VolWebEndpointURL + "/api/cases/" + $CaseId + "/"

# Check if the case exist before doing anything

# Check if the case exist before doing anything
$response = Invoke-WebRequest -Uri $CaseUri -Method GET -Headers $Headers

if($response.StatusCode -eq 200) {
    Write-Host "Case exists."
   
    # parsing 'case_bucket_id' from the response.
    $caseBucketID = (ConvertFrom-Json $response.Content).case_bucket_id
   
    # Initialize AWS settings
    Set-AWSCredentials -AccessKey $BucketEndpointId -SecretKey $BucketEndpointKey
    $AWSConfig = New-AWSCredentials -AccessKey $BucketEndpointId -SecretKey $BucketEndpointKey

    # Get all files from the directory
    
    $files = Get-ChildItem -Path $MemoryDumpsPath -File -Recurse

    # Loop through each file and upload to the bucket
    foreach($file in $files)
    {
        Write-Host "Uploading $($file.Name) to S3 bucket... "

        Write-S3Object -BucketName $caseBucketID -File $file.FullName -Credential $AWSConfig -Endpoint  "$($BucketEndpointURL)" -Region us-east-1
        $uploadedObjectInfo = Get-S3Object -BucketName $caseBucketID -Key $file.Name -Credential $AWSConfig  -Endpoint "$($BucketEndpointURL)" -Region us-east-1

        # Extracting ETag from the object's metadata
        $fileETag = $uploadedObjectInfo.ETag

        Write-Host "Uploaded $($file.Name) to S3 bucket. ETag: $($fileETag)"

        # Evidence data to be created
        $evidenceBody = @{
            dump_name = $($file.Name)
            dump_etag = $fileETag
            dump_os = "Windows"
            dump_linked_case = $CaseId
        }

        # Convert the body data to a JSON string
        $jsonBody = $evidenceBody | ConvertTo-Json

        # Create the headers with the authorization token
        $headers = @{
            "Authorization" = "Token $Token"
            "Content-Type" = "application/json"
        }

        $EvidencesUri = $VolWebEndpointURL + "/api/evidences/"

        # Make the HTTP POST request
        $response = Invoke-RestMethod -Uri $EvidencesUri -Method Post -Headers $headers -Body $jsonBody -ContentType "application/json"

        # Output the response
        $response | ConvertTo-Json

    }
        
}
else {
    Write-Host "Case does not exist."
    Write-S3Object -EndpointUrl 
    
}