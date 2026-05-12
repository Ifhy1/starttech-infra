# 1. Create the S3 Bucket for the React Frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "muchtodo-frontend-${var.environment}" # Use a unique name

  tags = {
    Name        = "Frontend-Bucket"
    Environment = var.environment
  }
}

# 2. Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "frontend_config" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html" # React handles routing, so error should point to index
  }
}

# 3. Public Access Block (We'll allow public reads for the website)
resource "aws_s3_bucket_public_access_block" "frontend_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Output the Bucket Name and Website URL
output "bucket_name" {
  value = aws_s3_bucket.frontend_bucket.id
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.frontend_config.website_endpoint
}

# 5. Allow public read access to the bucket objects
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
      },
    ]
  })
  
  # This ensures the public access block is handled before the policy
  depends_on = [aws_s3_bucket_public_access_block.frontend_access]
}