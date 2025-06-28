
variable "ENVIRONMENT" {
    type    = string
    default = "development"
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-0e9bbd70d26d7cf4f"
        us-east-2 = "ami-05692172625678b4e"
        us-west-2 = "ami-02c8896b265d8c480"
        eu-west-1 = "ami-0cdd3aca00188622e"
    }
}

variable "AWS_REGION" {
default = "us-east-1"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}
