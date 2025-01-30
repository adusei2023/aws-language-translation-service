import json
import boto3
import os

translate = boto3.client('translate')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Read S3 bucket names from environment variables
    requests_bucket = os.environ['REQUESTS_BUCKET']
    responses_bucket = os.environ['RESPONSES_BUCKET']
    
    # Get the input JSON from the event
    record = event['Records'][0]
    input_bucket = record['s3']['bucket']['name']
    input_key = record['s3']['object']['key']
    
    # Download the input file from S3
    response = s3.get_object(Bucket=input_bucket, Key=input_key)
    text_data = json.loads(response['Body'].read().decode('utf-8'))
    
    source_lang = text_data['source_language']
    target_lang = text_data['target_language']
    text = text_data['text']
    
    # Perform translation
    translated_text = translate.translate_text(
        Text=text,
        SourceLanguageCode=source_lang,
        TargetLanguageCode=target_lang
    )['TranslatedText']
    
    # Save the translated text to S3
    output_key = f"translated_{input_key}"
    s3.put_object(
        Bucket=responses_bucket,
        Key=output_key,
        Body=json.dumps({"translated_text": translated_text})
    )

    return {
        'statusCode': 200,
        'body': json.dumps({"message": "Translation complete", "translated_text": translated_text})
    }
