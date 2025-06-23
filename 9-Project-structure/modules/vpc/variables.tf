#Define Variable for Custom Module VPC

variable "AWS_REGION" {
    type    = string
    default = "us-east-1"
}

variable "ENVIRONMENT" {
    type    = string
    default = ""
}
