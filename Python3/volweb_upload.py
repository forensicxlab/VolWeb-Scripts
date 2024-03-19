import requests
import boto3
import os
from pathlib import Path
import json

token = "YOUR_API_TOKEN"
case_id = "1"
vol_web_endpoint_url = "http(s)://volweb-instance"
bucket_endpoint_url = vol_web_endpoint_url + ":9000"
bucket_endpoint_id = "user"
bucket_endpoint_key = "password"
memory_dumps_path = "./path/to/dump/folder"
self_signed = True 
OS = "Windows" # Possible values: "Windows" / "Linux"

headers = {"Authorization": f"Token {token}"}

case_uri = f"{vol_web_endpoint_url}/api/cases/{case_id}/"


# Disable SSL verification if self_signed is True
verify_ssl = not self_signed

# Check if the case exists before doing anything
try:
    response = requests.get(case_uri, headers=headers, verify=verify_ssl)
    response.raise_for_status()
    print("Case exists.")

    # parsing 'case_bucket_id' from the response.
    case_bucket_id = response.json()["case_bucket_id"]

    # Initialize AWS settings
    s3 = boto3.client(
        "s3",
        endpoint_url=bucket_endpoint_url,
        aws_access_key_id=bucket_endpoint_id,
        aws_secret_access_key=bucket_endpoint_key,
        region_name="us-east-1",
        verify=(not self_signed),
    )

    for root, dirs, files in os.walk(memory_dumps_path):
        for filename in files:
            file_path = os.path.join(root, filename)
            print(f"Uploading {filename} to S3 bucket... ")

            s3.upload_file(file_path, case_bucket_id, filename)
            uploaded_object_info = s3.head_object(Bucket=case_bucket_id, Key=filename)

            file_etag = uploaded_object_info["ETag"]
            print(f"Uploaded {filename} to S3 bucket. ETag: {file_etag}")

            evidence_body = {
                "dump_name": filename,
                "dump_etag": file_etag,
                "dump_os": OS,
                "dump_linked_case": case_id,
            }

            evidences_uri = f"{vol_web_endpoint_url}/api/evidences/"
            response = requests.post(
                evidences_uri,
                headers={**headers, "Content-Type": "application/json"},
                json=evidence_body,
                verify=verify_ssl,
            )
            print(f"File uploaded : {response.json()}")

except requests.HTTPError as e:
    print(f"An error occurred: {e}")
