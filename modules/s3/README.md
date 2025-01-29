# S3 Module

This module creates two Amazon S3 buckets for the translation service:

- **Requests Bucket**: Stores incoming translation requests.
- **Responses Bucket**: Stores translated responses and logs.

## Outputs

- `requests_bucket_name`: The name of the translation requests bucket.
- `responses_bucket_name`: The name of the translation responses bucket.

## Security Features

- Blocks all public access.
- Only allows AWS Lambda to write to the requests bucket.
- Only allows AWS Lambda to write and read from the responses bucket.
