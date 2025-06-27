// API Gateway URL - will be replaced by Terraform
const API_URL = '${api_gateway_url}';

console.log('API URL:', API_URL);

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
                    showResult(result.translated_text, sourceLanguage, targetLanguage, inputText);
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

    function showResult(translatedText, sourceLanguage, targetLanguage, originalText) {
        translatedTextDiv.innerHTML = `
            <div class="translation-result">
                <div class="original-text">
                    <strong>Original ($${getLanguageName(sourceLanguage)}):</strong>
                    <p>"$${originalText}"</p>
                </div>
                <div class="translated-text-content">
                    <strong>Translation ($${getLanguageName(targetLanguage)}):</strong>
                    <p>"$${translatedText}"</p>
                </div>
            </div>
        `;
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