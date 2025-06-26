import json
import boto3
import logging
from datetime import datetime
import uuid

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS Translate client
translate = boto3.client('translate')

def lambda_handler(event, context):
    """
    AWS Lambda handler for language translation service
    """
    # Generate tracking IDs
    timestamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    unique_id = str(uuid.uuid4())
    
    logger.info(f"Request ID: {unique_id}, Timestamp: {timestamp}")
    logger.info(f"Received event: {json.dumps(event)}")

    # CORS headers
    cors_headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Methods': 'GET,OPTIONS,POST,PUT'
    }
    
    try:
        # Handle OPTIONS request for CORS preflight
        if event.get('httpMethod') == 'OPTIONS':
            logger.info("Handling OPTIONS request for CORS")
            return {
                'statusCode': 200,
                'headers': cors_headers,
                'body': json.dumps({'message': 'CORS preflight successful'})
            }
        
        # Handle GET request for health check
        if event.get('httpMethod') == 'GET':
            logger.info("Handling GET request for health check")
            return {
                'statusCode': 200,
                'headers': cors_headers,
                'body': json.dumps({
                    'message': 'Translation API is healthy',
                    'version': '1.0',
                    'timestamp': timestamp
                })
            }
        
        # Handle POST request for translation
        if event.get('httpMethod') != 'POST':
            logger.warning(f"Unsupported method: {event.get('httpMethod')}")
            return {
                'statusCode': 405,
                'headers': cors_headers,
                'body': json.dumps({'error': 'Method not allowed. Use POST for translation.'})
            }
        
        # Parse request body
        if not event.get('body'):
            logger.error("Missing request body")
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps({'error': 'Request body is required'})
            }
        
        # Parse JSON body
        try:
            if isinstance(event['body'], str):
                request_data = json.loads(event['body'])
            else:
                request_data = event['body']
        except json.JSONDecodeError as e:
            logger.error(f"Invalid JSON: {str(e)}")
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps({'error': 'Invalid JSON in request body'})
            }
        
        logger.info(f"Parsed request: {json.dumps(request_data)}")
        
        # Extract and validate fields
        source_language = request_data.get('source_language')
        target_language = request_data.get('target_language')
        text = request_data.get('text')
        
        # Validation
        if not source_language:
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps({'error': 'source_language is required'})
            }
        
        if not target_language:
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps({'error': 'target_language is required'})
            }
        
        if not text or not text.strip():
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps({'error': 'text is required and cannot be empty'})
            }
        
        if source_language == target_language:
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps({'error': 'source_language and target_language cannot be the same'})
            }
        
        logger.info(f"Translating: '{text}' from {source_language} to {target_language}")
        
        # Call AWS Translate
        try:
            response = translate.translate_text(
                Text=text,
                SourceLanguageCode=source_language,
                TargetLanguageCode=target_language
            )
            
            translated_text = response['TranslatedText']
            logger.info(f"Translation successful: {translated_text}")
            
            # Return success response
            return {
                'statusCode': 200,
                'headers': cors_headers,
                'body': json.dumps({
                    'original_text': text,
                    'translated_text': translated_text,
                    'source_language': source_language,
                    'target_language': target_language,
                    'timestamp': timestamp,
                    'request_id': unique_id
                })
            }
            
        except Exception as translate_error:
            logger.error(f"Translation service error: {str(translate_error)}")
            return {
                'statusCode': 500,
                'headers': cors_headers,
                'body': json.dumps({
                    'error': 'Translation service failed',
                    'details': str(translate_error)
                })
            }
        
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}", exc_info=True)
        return {
            'statusCode': 500,
            'headers': cors_headers,
            'body': json.dumps({
                'error': 'Internal server error',
                'request_id': unique_id
            })
        }
