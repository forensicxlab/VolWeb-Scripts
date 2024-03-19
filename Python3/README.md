# VolWeb-Scripts/Pyhton3 

## volweb_upload.py

- Targeted OS: Windows/Linux
- Description: The script will upload all of the target folder files to VolWeb. The solution is compatible with the MinIO and AWS storage. All the evidences will be created and bind to the provided Case No. The analysis will start automatically.

### Parameters
Modify the following parameters in the script:
- token:
- case_id:
- vol_web_endpoint_url: The URL of your VolWeb Platform.
- bucket_endpoint_url: The URL of the VolWeb MinIO instance to create the bucket. Default is $vol_web_endpoint_url:9000
- bucket_endpoint_id: The ID for the VolWeb MinIO instance to access the bucket
- bucket_endpoint_key: The key for the VolWeb MinIO instance to access the bucket
- memory_dumps_path: The folder from where the dumps will be uploaded
- self_signed: True/False if you are using a certificate on VolWeb/MinIO not trusted by the OS you are uploading from
- os: Linux/Windows 

### Guide: 

1. Install the requirement: `pip3 install boto3 requests`

Example usage: "python3 volweb_upload.py"
