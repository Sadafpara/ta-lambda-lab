terraform {
  backend "s3" {
    bucket = "ta-terraform-tfstates-923372466541"
    key    = "tf-lab/lambda-function/terraform.tfstates"
    region = "eu-central-1"
    dynamodb_table = "terraform-lock"
    
  }
}