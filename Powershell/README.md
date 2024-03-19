# VolWeb-Scripts/PowerShell 

## volweb_upload.ps1

- Targeted OS: Windows
- Description: The script will upload all of the target folder files to VolWeb. The solution is compatible with the MinIO and AWS storage. All the evidences will be created and bind to the Case No. The analysis will start automatically.

### Arguments
- `Token`: Your VolWeb API Token
- `CaseId`: The ID of the case you want to upload your evidences.
- `VolWebEndpointURL`: The URL of your VolWeb Platform.
- `BucketEndpointURL`: The URL of the VolWeb MinIO instance to create the bucket. Default is $VolWebEndpointURL:9000 (option)
- `BucketEndpointId`: The ID for the VolWeb MinIO instance to access the bucket (mandatory)
- `BucketEndpointKey`: The key for the VolWeb MinIO instance to access the bucket (mandatory)
- `MemoryDumpsPath`: The path containing the memory dumps you need to upload. (mandatory)
- `SelfSigned`: $true if your VolWeb instance is using self signed certificates (optional)

### Guide: 

1. Install the requirement: `Install-Package -Name AWSPowerShell`


Example usage using MIN.IO: `.\volweb_upload.ps1 -Token mysupersecrettoken -VolWebEndpointURL "https://my-volweb-instance.ex" -CaseId 1 -BucketEndpointId "user" -BucketEndpointKey "password" -MemoryDumpsPath "C:\Users\Foo\MemoryImages\" -SelfSigned $true`
