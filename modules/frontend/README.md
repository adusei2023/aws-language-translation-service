# 🌐 Frontend Module

## Overview
This module creates an S3 bucket configured for static website hosting to serve the translation service's web interface. It includes HTML, CSS, and JavaScript files that provide a user-friendly interface for the translation API.

## 🏗️ Architecture
- **Static Website Hosting**: S3 bucket configured for web hosting
- **Responsive Design**: Modern, mobile-friendly interface
- **API Integration**: Direct connection to API Gateway endpoint
- **Error Handling**: Custom error pages and user feedback
- **CORS Compatible**: Designed to work with API Gateway CORS setup

## 📦 Resources Created
- `aws_s3_bucket` - Frontend hosting bucket
- `aws_s3_bucket_website_configuration` - Static website configuration
- `aws_s3_bucket_public_access_block` - Public access settings for website
- `aws_s3_object` - Web files (index.html, styles.css, app.js, error.html)
- `aws_s3_bucket_policy` - Public read policy for website access

## 📋 Variables

| Variable | Type | Description |
|----------|------|-------------|
| `bucket_name` | `string` | Name of the S3 bucket for frontend hosting |
| `api_gateway_url` | `string` | API Gateway URL for the translation service |
| `project` | `string` | Project name for tagging |
| `environment` | `string` | Environment name (dev, staging, production) |
| `tags` | `map(string)` | Additional tags for resources |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `website_url` | URL of the static website |
| `bucket_name` | Name of the frontend S3 bucket |

## 🚀 Usage

```hcl
module "frontend" {
  source          = "./modules/frontend"
  bucket_name     = "aws-translate-frontend-production"
  project         = "aws-translate"
  environment     = "production"
  api_gateway_url = module.api_gateway.api_gateway_endpoint
  tags = {
    CreatedBy = "Samuel Adusei Boateng"
    Purpose   = "Translation Web Interface"
  }
}
```

## 📁 Frontend Files

### index.html
- Main application page
- Responsive design with Bootstrap
- Language selection dropdowns
- Translation input/output areas
- Real-time API integration

### styles.css
- Modern CSS styling
- Responsive grid layout
- Clean, professional appearance
- Mobile-optimized design

### app.js
- JavaScript application logic
- API Gateway integration
- Form handling and validation
- Error handling and user feedback
- Language pair management

### error.html
- Custom 404 error page
- User-friendly error messaging
- Navigation back to main app

## 🎨 Features
- **Multi-language Support**: Interface for 9+ language pairs
- **Real-time Translation**: Instant API calls on form submission
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Error Handling**: Graceful handling of API errors
- **Loading States**: User feedback during translation
- **Copy to Clipboard**: Easy result copying functionality

## 🔧 API Integration
The frontend automatically configures the API Gateway URL and handles:
- POST requests to `/translate` endpoint
- JSON request/response formatting
- CORS headers and preflight requests
- Error response handling

## 🌐 Supported Languages
- English ↔ Spanish
- English ↔ French
- English ↔ German
- English ↔ Chinese
- English ↔ Japanese
- English ↔ Korean
- English ↔ Portuguese
- English ↔ Italian
- English ↔ Russian

## 🔒 Security
- **Public Read Access**: Only for website files
- **HTTPS Redirect**: Recommended for production
- **Content Security Policy**: Can be added via CloudFront
- **Input Sanitization**: Client-side validation

## 📱 Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Progressive enhancement for older browsers

## 💰 Cost Optimization
- **Static Files**: Minimal storage costs
- **S3 Website Hosting**: Cost-effective hosting solution
- **No Server Costs**: Pure client-side application
- **CDN Ready**: Can be paired with CloudFront for global distribution

## 📝 Notes
- Website URL uses HTTP by default (HTTPS requires CloudFront)
- API Gateway URL is automatically injected into JavaScript
- Files are uploaded during Terraform deployment
- Static website hosting is enabled automatically
