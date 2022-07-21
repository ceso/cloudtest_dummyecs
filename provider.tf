terraform {
    backend "s3" {
        bucket = "CHANGEME"
        key    = "CHANGEME"
        region = "CHANGEME"
    }
}

provider "aws" {
    region = "CHANGEME"
    shared_config_files      = ["CHANGEME"]
    shared_credentials_files = ["CHANGME"]
}