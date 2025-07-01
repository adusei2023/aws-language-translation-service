# 🌐 AWS Language Translation Service

A complete serverless language translation application built with AWS Lambda, API Gateway, S3, and Terraform Infrastructure as Code.

## ✨ Features

- **Real-time Translation**: Instant translation between multiple languages using AWS Translate
- **Serverless Architecture**: Built on AWS Lambda for automatic scaling and cost-efficiency
- **Web Application**: Complete frontend hosted on S3 with static website hosting
- **RESTful API**: API Gateway with proper CORS configuration for web applications
- **Security First**: KMS encryption, IAM roles with least privilege, and secure data handling
- **Infrastructure as Code**: Fully automated deployment with Terraform modules
- **Production Ready**: CloudWatch logging, X-Ray tracing, and comprehensive error handling

## 🏗️ Architecture

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌──────────────┐
│   Frontend  │───▶│ API Gateway  │───▶│   Lambda    │───▶│ AWS Translate│
│   (S3 Web)  │    │   (CORS)     │    │  Function   │    │   Service    │
└─────────────┘    └──────────────┘    └─────────────┘    └──────────────┘
                           │                     │
                           ▼                     ▼
                   ┌──────────────┐    ┌─────────────┐
                   │ CloudWatch   │    │ S3 Buckets  │
                   │    Logs      │    │(Req/Resp)   │
                   └──────────────┘    └─────────────┘
```

## 🌍 Supported Languages

- **English** (en) ↔ **Spanish** (es)
- **English** (en) ↔ **French** (fr)  
- **English** (en) ↔ **German** (de)
- **English** (en) ↔ **Chinese** (zh)
- **English** (en) ↔ **Japanese** (ja)
- **English** (en) ↔ **Korean** (ko)
- **English** (en) ↔ **Portuguese** (pt)
- **English** (en) ↔ **Italian** (it)
- **English** (en) ↔ **Russian** (ru)

## 📁 Project Structure

```
language-translation-aws-iac-solution/
├── 📄 main.tf                           # Root Terraform configuration
├── 📄 variables.tf                      # Input variables and configuration
├── 📄 outputs.tf                        # Output values (URLs, names, etc.)
├── 📄 terraform.tfvars.example          # Example variables file
├── 📄 README.md                         # This documentation
├── 📄 .gitignore                        # Git ignore patterns
│
├── 📁 modules/                          # Terraform modules
│   ├── 📁 api_gateway/                  # API Gateway module
│   │   ├── 📄 main.tf                   # API Gateway resources
│   │   ├── 📄 variables.tf              # API Gateway variables
│   │   └── 📄 outputs.tf                # API Gateway outputs
│   │
│   ├── 📁 lambda/                       # Lambda function module
│   │   ├── 📄 main.tf                   # Lambda configuration
│   │   ├── 📄 variables.tf              # Lambda variables
│   │   ├── 📄 outputs.tf                # Lambda outputs
│   │   └── 📄 lambda_translate.py       # Python translation function
│   │
│   ├── 📁 frontend/                     # Frontend hosting module
│   │   ├── 📄 main.tf                   # S3 static website config
│   │   ├── 📄 variables.tf              # Frontend variables
│   │   ├── 📄 outputs.tf                # Frontend outputs
│   │   ├── 📄 index.html                # Main web page
│   │   ├── 📄 style.css                 # Styling
│   │   └── 📄 app.js                    # Frontend JavaScript
│   │
│   ├── 📁 s3/                           # S3 storage module
│   │   ├── 📄 main.tf                   # Request/Response buckets
│   │   ├── 📄 variables.tf              # S3 variables
│   │   └── 📄 outputs.tf                # S3 outputs
│   │
│   └── 📁 kms/                          # KMS encryption module
│       ├── 📄 main.tf                   # KMS key configuration
│       ├── 📄 variables.tf              # KMS variables
│       └── 📄 outputs.tf                # KMS outputs
```

## 🚀 Quick Start

### Prerequisites

- **AWS CLI** configured with appropriate credentials
- **Terraform** v1.0+ installed
- **AWS Account** with necessary permissions
- **Git** for version control

### 1. Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/language-translation-aws-iac-solution.git
cd language-translation-aws-iac-solution
```

### 2. Configure Variables

```bash
# Copy example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Deploy to AWS (takes 2-3 minutes)
terraform apply -auto-approve
```

### 4. Get Your URLs

```bash
# View all outputs
terraform output

# Your application URLs will be displayed:
# - Frontend URL: http://aws-translate-frontend-production.s3-website-us-east-1.amazonaws.com
# - API URL: https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com/production
```

## 🛠️ Usage

### Web Interface

1. **Open** the Frontend URL in your browser
2. **Enter text** in the source language field
3. **Select** source and target languages
4. **Click "Translate"** to get instant translation
5. **View results** in the target language field

### API Usage

#### Translation Request

```bash
curl -X POST "https://YOUR_API_GATEWAY_URL/production/translate" \
  -H "Content-Type: application/json" \
  -d '{
    "source_language": "en",
    "target_language": "es", 
    "text": "Hello world. This is a test translation."
  }'
```

#### Expected Response

```json
{
  "original_text": "Hello world. This is a test translation.",
  "translated_text": "Hola mundo. Esta es una traducción de prueba.",
  "source_language": "en",
  "target_language": "es",
  "timestamp": "20250626T123456Z",
  "request_id": "uuid-here"
}
```

#### Health Check

```bash
curl -X GET "https://YOUR_API_GATEWAY_URL/production/translate"
```

## 🔧 Technical Details

### Lambda Function

- **Runtime**: Python 3.12
- **Memory**: 128 MB (optimized for cost)
- **Handler**: `lambda_translate.lambda_handler`
- **Timeout**: 30 seconds
- **Architecture**: x86_64

### API Gateway

- **Type**: REST API
- **CORS**: Enabled for web applications
- **Methods**: GET (health), POST (translate), OPTIONS (preflight)
- **Integration**: Lambda Proxy Integration
- **Stage**: production

### S3 Configuration

- **Frontend Bucket**: Static website hosting enabled
- **Request Bucket**: Stores translation requests
- **Response Bucket**: Stores translation responses
- **Encryption**: KMS encryption at rest

### Security Features

- **IAM Roles**: Least privilege access
- **KMS Encryption**: All data encrypted at rest
- **CORS Headers**: Secure cross-origin requests
- **CloudWatch Logging**: Full request/response logging
- **X-Ray Tracing**: Performance monitoring

## 🧪 Testing

### Manual Testing

```bash
# Test Lambda function directly
aws lambda invoke \
  --function-name translation-lambda \
  --payload '{"httpMethod": "POST", "body": "{\"source_language\": \"en\", \"target_language\": \"es\", \"text\": \"Hello\"}"}' \
  --cli-binary-format raw-in-base64-out \
  response.json

# View response
cat response.json
```

### Load Testing

```bash
# Simple load test
for i in {1..10}; do
  curl -X POST "https://YOUR_API_GATEWAY_URL/production/translate" \
    -H "Content-Type: application/json" \
    -d '{"source_language": "en", "target_language": "es", "text": "Test '$i'"}' &
done
wait
```

## 📊 Monitoring

### CloudWatch Logs

```bash
# View Lambda logs
aws logs tail /aws/lambda/translation-lambda --follow

# View API Gateway logs
aws logs tail API-Gateway-Execution-Logs_YOUR_API_ID/production --follow
```

### Metrics Dashboard

Access CloudWatch dashboard for:
- Lambda invocations and errors
- API Gateway requests and latency
- S3 bucket usage
- KMS key usage

## 🛡️ Security Considerations

### IAM Permissions

- Lambda execution role has minimal permissions
- API Gateway has specific invoke permissions
- S3 buckets use bucket policies for access control

### Data Protection

- All S3 objects encrypted with KMS
- In-transit encryption via HTTPS
- No sensitive data logged

### Network Security

- API Gateway deployed in AWS public subnet
- Lambda functions in AWS managed VPC
- S3 buckets with public access blocked

## 🐛 Troubleshooting

### Common Issues

#### 502 Bad Gateway
```bash
# Check Lambda logs
aws logs tail /aws/lambda/translation-lambda --since 5m

# Verify Lambda permissions
aws lambda get-policy --function-name translation-lambda
```

#### CORS Errors
```bash
# Test OPTIONS request
curl -X OPTIONS "https://YOUR_API_GATEWAY_URL/production/translate" \
  -H "Origin: YOUR_FRONTEND_URL" -v

# Check CORS configuration in API Gateway console
```

#### Translation Errors
```bash
# Verify AWS Translate service limits
aws translate describe-text-translation-job --job-id test

# Check supported language pairs
aws translate list-languages
```

### Debug Mode

Enable detailed logging:

```bash
# Set Terraform debug mode
export TF_LOG=DEBUG

# Enable Lambda debug logging
aws lambda put-function-configuration \
  --function-name translation-lambda \
  --environment Variables='{LOG_LEVEL=DEBUG}'
```

## 💰 Cost Optimization

### Estimated Monthly Costs (1000 requests)

- **Lambda**: ~$0.20 (128MB, 1000 invocations)
- **API Gateway**: ~$3.50 (1000 requests)
- **S3**: ~$0.05 (storage + requests)
- **AWS Translate**: ~$15.00 (1000 translations)
- **CloudWatch**: ~$0.50 (logs retention)
- **Total**: ~$19.25/month

### Cost Saving Tips

- Use shorter text for translations
- Implement caching for repeated translations
- Monitor CloudWatch logs retention
- Use S3 lifecycle policies for old data

## 🔄 CI/CD Pipeline

### GitHub Actions (Optional)

```yaml
# .github/workflows/deploy.yml
name: Deploy AWS Translation Service

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
    - name: Terraform Deploy
      run: |
        terraform init
        terraform apply -auto-approve
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## 🧹 Cleanup

### Destroy Infrastructure

```bash
# Remove all AWS resources
terraform destroy -auto-approve

# Verify cleanup
terraform show
```

### Manual Cleanup (if needed)

```bash
# Delete S3 objects first
aws s3 rm s3://YOUR_BUCKET_NAME --recursive

# Delete CloudWatch logs
aws logs delete-log-group --log-group-name /aws/lambda/translation-lambda
```

## 🤝 Contributing

### Development Setup

```bash
# Fork and clone repository
git clone https://github.com/YOUR_USERNAME/language-translation-aws-iac-solution.git

# Create feature branch
git checkout -b feature/new-feature

# Make changes and test
terraform plan

# Submit pull request
```

### Code Standards

- Use Terraform best practices
- Include comprehensive comments
- Follow AWS naming conventions
- Add tests for new features
- Update documentation

## 👥 Project Team

### CloudFormation Group Members

**Samuel Adusei Boateng** - *Project Lead & AWS Infrastructure Developer*
- LinkedIn: https://www.linkedin.com/in/samueladuseiboateng/
- Role: Terraform Infrastructure, Lambda Development, API Gateway Configuration, Frontend Development
- Contributions: Complete architecture design and 

**Irene Vanessa Vifah** - *Project Team  & Front-end lead*
- LinkedIn: https://www.linkedin.com/in/irenevanessavifah/

- Role: Terraform Infrastructure, Front-end Development, API Gateway Configuration
- Contributions: Built and implemented front-end

*Additional team members can be added here*

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Useful Links

- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [AWS API Gateway Documentation](https://docs.aws.amazon.com/apigateway/)
- [AWS Translate Documentation](https://docs.aws.amazon.com/translate/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)

## 📞 Support

For issues and questions:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Review CloudWatch logs
3. Open an issue on GitHub
4. Contact the project team

---

**🚀 Built with AWS, Terraform, and ♥️ by the CloudFormation Group**