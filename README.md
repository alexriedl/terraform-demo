# Terraform all the Planets #

## Setup ##
1. Install Terraform
2. Navigate to environment folder (ie `terraform/accounts/sandbox/us-east-1/dev`)
3. Initialize terraform `terraform init`
4. Or update `terraform get -update`
5. Plan: `terraform plan`
6. Apply: `terraform apply`
8. Verify: In a web browser navigate to the url that is outputed from terraform (Append `/messages` to the url. Example: `https://m8qi12m08e.execute-api.us-east-1.amazonaws.com/staging/messages`)
