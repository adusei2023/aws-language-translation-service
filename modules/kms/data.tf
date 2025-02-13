# Retrieves the AWS account details (specifically, the account ID).
# This is used in the key policy to reference the account's root user.
data "aws_caller_identity" "current_account" {
    
}
