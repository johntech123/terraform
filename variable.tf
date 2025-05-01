variable "instance_type" {
  description = "ec2-instance-variable"
  type = string
}

variable "ami_id" {
  description = "ami-value"
  type = string
}

variable "instance_name" {
    type = string 
    description = "name-tag-for-instance"
}
