import json
import boto3
import logging
import os
from datetime import datetime
import uuid
from collections import OrderedDict

# Configure logging
logger = logging.getLogger()
log_level = os.environ.get('LOG_LEVEL', 'INFO')
logger.setLevel(getattr(logging, log_level))

# Initialize AWS Translate client outside handler for connection reuse
translate = boto3.client('translate')

# LRU cache implementation for repeated translations
class LRUCache:
    def __init__(self, capacity: int):
        self.cache = OrderedDict()
        self.capacity = capacity
    
    def get(self, key: str):
        if key not in self.cache:
            return None
        # Move to end to mark as recently used
        self.cache.move_to_end(key)
        return self.cache[key]
    
    def put(self, key: str, value: str):
        if key in self.cache:
            # Remove existing key first
            del self.cache[key]
        # Add/update value at the end
        self.cache[key] = value
        # Evict least recently used item if over capacity
        if len(self.cache) > self.capacity:
            self.cache.popitem(last=False)

# Initialize cache
translation_cache = LRUCache(capacity=100)

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
        
        # Generate cache key using a safe delimiter to prevent collisions
        # Using | as delimiter since it's rarely used in natural language text
        cache_key = f"{source_language}|{target_language}|{text}"
        
        # Check cache first for improved performance
        cached_translation = translation_cache.get(cache_key)
        is_cached = cached_translation is not None
        
        if is_cached:
            logger.info(f"Cache hit - returning cached translation. Cache size: {len(translation_cache.cache)}")
            translated_text = cached_translation
        else:
            # Call AWS Translate
            try:
                response = translate.translate_text(
                    Text=text,
                    SourceLanguageCode=source_language,
                    TargetLanguageCode=target_language
                )
                
                translated_text = response['TranslatedText']
                
                # Store in LRU cache
                translation_cache.put(cache_key, translated_text)
                logger.info(f"Translation cached. Cache size: {len(translation_cache.cache)}")
                
                logger.info(f"Translation successful: {translated_text}")
                
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
                'request_id': unique_id,
                'cached': is_cached
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
