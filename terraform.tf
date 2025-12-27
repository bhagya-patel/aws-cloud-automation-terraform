terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }

  #for a remote infra

backend "s3" {
  bucket         = "bhagya1-bucket"
  key            = "terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "bhagya1-table"
  
}

}