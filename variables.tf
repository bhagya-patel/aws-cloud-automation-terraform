variable "ec2_instance_type" {
    type        = string
    default     = "t3.micro"
}

variable "ec2_ami_id" {
    type        = string
    default     = "ami-0ecb62995f68bb549"  # Ubuntu AMI
}

variable "ec2_default_root_volume_size" {
    type        = number
    default     = 10
}

variable "env" {
    type        = string
    default     = "dev"
}
