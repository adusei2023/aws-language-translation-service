// API Gateway URL - will be replaced by Terraform
const API_URL = '${api_gateway_url}';

console.log('API URL:', API_URL);

// Translation cache for better performance
const translationCache = new Map();
const MAX_CACHE_SIZE = 50;

// Simple hash function for creating cache keys
function hashString(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
        const char = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + char;
        hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.toString(36);
}

// Debounce function to prevent excessive API calls
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('translationForm');
    const resultDiv = document.getElementById('result');
    const errorDiv = document.getElementById('error');
    const translatedTextDiv = document.getElementById('translatedText');
    const errorMessageDiv = document.getElementById('errorMessage');
    const translateBtn = document.getElementById('translateBtn');
    const btnText = document.getElementById('btnText');
    const btnLoader = document.getElementById('btnLoader');
    const copyBtn = document.getElementById('copyBtn');

    if (form) {
        form.addEventListener('submit', async (e) => {
            e.preventDefault();

            const sourceLanguage = document.getElementById('sourceLanguage').value;
            const targetLanguage = document.getElementById('targetLanguage').value;
            const inputText = document.getElementById('inputText').value.trim();

            // Hide previous results/errors
            resultDiv.classList.add('hidden');
            errorDiv.classList.add('hidden');

            // Validation
            if (!inputText) {
                showError('Please enter text to translate.');
                return;
            }

            if (sourceLanguage === targetLanguage) {
                showError('Source and target languages cannot be the same.');
                return;
            }

            // Show loading state
            translateBtn.disabled = true;
            btnText.classList.add('hidden');
            btnLoader.classList.remove('hidden');

            try {
                // Generate secure cache key using hash to prevent collisions
                const cacheKey = hashString(`${sourceLanguage}|${targetLanguage}|${inputText}`);
                
                // Check local cache first with proper LRU behavior
                if (translationCache.has(cacheKey)) {
                    console.log('Using cached translation');
                    const cachedResult = translationCache.get(cacheKey);
                    
                    // Move to end for LRU behavior (delete and re-add)
                    translationCache.delete(cacheKey);
                    translationCache.set(cacheKey, cachedResult);
                    
                    showResult(cachedResult.translated_text, sourceLanguage, targetLanguage, inputText, true);
                    
                    // Reset button state
                    translateBtn.disabled = false;
                    btnText.classList.remove('hidden');
                    btnLoader.classList.add('hidden');
                    return;
                }
                
                const requestBody = {
                    source_language: sourceLanguage,
                    target_language: targetLanguage,
                    text: inputText
                };

                console.log('Request body:', requestBody);

                const response = await fetch(`$${API_URL}/translate`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(requestBody)
                });

                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);

                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('API Error Response:', errorText);
                    throw new Error(`HTTP $${response.status}: $${errorText}`);
                }

                const result = await response.json();
                console.log('Translation result:', result);

                if (result.translated_text) {
                    // Store in cache
                    if (translationCache.size >= MAX_CACHE_SIZE) {
                        // Remove oldest entry if cache is full
                        const firstKey = translationCache.keys().next().value;
                        translationCache.delete(firstKey);
                    }
                    translationCache.set(cacheKey, result);
                    
                    showResult(result.translated_text, sourceLanguage, targetLanguage, inputText, result.cached || false);
                } else {
                    throw new Error('No translated text in response');
                }

            } catch (err) {
                console.error('Translation error:', err);
                showError('Translation failed: ' + err.message + '. Check console for details.');
            } finally {
                // Reset button state
                translateBtn.disabled = false;
                btnText.classList.remove('hidden');
                btnLoader.classList.add('hidden');
            }
        });
    }

    function showResult(translatedText, sourceLanguage, targetLanguage, originalText, cached = false) {
        // Clear previous content
        translatedTextDiv.innerHTML = '';
        
        // Create elements safely to prevent XSS
        const resultContainer = document.createElement('div');
        resultContainer.className = 'translation-result';
        
        // Original text section
        const originalDiv = document.createElement('div');
        originalDiv.className = 'original-text';
        const originalStrong = document.createElement('strong');
        originalStrong.textContent = `Original (${getLanguageName(sourceLanguage)}):`;
        const originalP = document.createElement('p');
        originalP.textContent = `"${originalText}"`;
        originalDiv.appendChild(originalStrong);
        originalDiv.appendChild(originalP);
        
        // Translated text section
        const translatedDiv = document.createElement('div');
        translatedDiv.className = 'translated-text-content';
        const translatedStrong = document.createElement('strong');
        translatedStrong.textContent = `Translation (${getLanguageName(targetLanguage)})`;
        
        // Add cache indicator if applicable
        if (cached) {
            const cacheSpan = document.createElement('span');
            cacheSpan.style.color = '#10b981';
            cacheSpan.style.fontSize = '0.9em';
            cacheSpan.textContent = ' (⚡ Cached)';
            translatedStrong.appendChild(cacheSpan);
        }
        
        const translatedP = document.createElement('p');
        translatedP.textContent = `"${translatedText}"`;
        translatedDiv.appendChild(translatedStrong);
        translatedDiv.appendChild(translatedP);
        
        // Assemble the result
        resultContainer.appendChild(originalDiv);
        resultContainer.appendChild(translatedDiv);
        translatedTextDiv.appendChild(resultContainer);
        
        resultDiv.classList.remove('hidden');
        errorDiv.classList.add('hidden');
    }

    function showError(message) {
        errorMessageDiv.textContent = message;
        errorDiv.classList.remove('hidden');
        resultDiv.classList.add('hidden');
    }

    function getLanguageName(code) {
        const languages = {
            'en': 'English',
            'es': 'Spanish',
            'fr': 'French',
            'de': 'German',
            'zh': 'Chinese',
            'ja': 'Japanese',
            'ko': 'Korean',
            'pt': 'Portuguese',
            'it': 'Italian',
            'ru': 'Russian'
        };
        return languages[code] || code;
    }

    // Copy to clipboard functionality
    if (copyBtn) {
        copyBtn.addEventListener('click', function() {
            const translatedContent = translatedTextDiv.querySelector('.translated-text-content p');
            if (translatedContent) {
                const textToCopy = translatedContent.textContent.replace(/"/g, '');
                navigator.clipboard.writeText(textToCopy).then(function() {
                    copyBtn.textContent = '✅ Copied!';
                    setTimeout(function() {
                        copyBtn.textContent = '📋 Copy Result';
                    }, 2000);
                }).catch(function(err) {
                    console.error('Failed to copy text: ', err);
                    copyBtn.textContent = '❌ Copy Failed';
                    setTimeout(function() {
                        copyBtn.textContent = '📋 Copy Result';
                    }, 2000);
                });
            }
        });
    }
});