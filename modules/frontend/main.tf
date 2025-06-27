# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET FOR FRONTEND
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
  tags   = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET WEBSITE CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET PUBLIC ACCESS BLOCK
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET POLICY
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

# ---------------------------------------------------------------------------------------------------------------------
# UPLOAD HTML FILE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  content      = data.template_file.index_html.rendered
  content_type = "text/html"
  etag         = md5(data.template_file.index_html.rendered)
}

# ---------------------------------------------------------------------------------------------------------------------
# UPLOAD CSS FILE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "styles.css"
  content      = data.template_file.styles_css.rendered
  content_type = "text/css"
  etag         = md5(data.template_file.styles_css.rendered)
}

# ---------------------------------------------------------------------------------------------------------------------
# UPLOAD JAVASCRIPT FILE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_object" "app_js" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "app.js"
  content      = data.template_file.app_js.rendered
  content_type = "application/javascript"
  etag         = md5(data.template_file.app_js.rendered)
}

# ---------------------------------------------------------------------------------------------------------------------
# ERROR HTML FILE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "error.html"
  content_type = "text/html"
  content      = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Error - Translation Service</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; text-align: center; }
        h1 { color: #e74c3c; }
    </style>
</head>
<body>
    <h1>Oops! Something went wrong</h1>
    <p>We're sorry, but the page you're looking for doesn't exist.</p>
    <a href="/">← Back to Translation Service</a>
</body>
</html>
EOF
}
