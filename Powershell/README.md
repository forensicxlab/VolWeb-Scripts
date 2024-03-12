# Powershell VolWeb Scripts

## volweb_upload.ps1

- Targeted OS: Windows
- Description: The script will upload all of the target folder files to VolWeb. The solution is compatible with the MinIO and AWS storage. All the evidences will be created and bind to the Case No. The analysis will start automatically.

### Guide: 

1. Install the requirement: `Install-Package -Name AWSPowerShell`


Example usage using MIN.IO: `.\volweb_upload.ps1 -Token mysupersecrettoken -VolWebEndpointURL "http://192.168.1.25:8001" -CaseId 1 -BucketEndpointURL "http://192.168.1.25:9000" -BucketEndpointId user -BucketEndpointKey password -MemoryDumpsPath "C:\Users\Foo\MemoryImages\" -UseSSL $false`
