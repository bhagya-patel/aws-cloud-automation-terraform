# key pair (login)
resource aws_key_pair my_key {
    key_name   = "bhagya1-key"
    public_key = file("terraform-key-ec2.pub")
}

# vpc & security group (networking)

resource "aws_default_vpc" "my_vpc" {
  
}

resource "aws_security_group" "my_sg" {
    name = "bhagya1_sg"
    description = "This will add a TF generated security group"
    vpc_id = aws_default_vpc.my_vpc.id

    #inbound rules
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH from anywhere"
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP from anywhere"
    }

    #outbound rules
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }

    #tags
    tags = {
        Name = "bhagya1_sg"
    }

}

# ec2 instance (server)

resource "aws_instance" "my_instance" {
    for_each = tomap({
        "bhagya1-ec2-instance" = "t3.micro"
        "new_ec2-instance"   = "t3.micro"
    })

    depends_on = [ aws_security_group.my_sg, aws_key_pair.my_key ]

    ami           = var.ec2_ami_id
    instance_type = each.value
    key_name      = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_sg.id]

    user_data = file("install_nginx.sh")

    root_block_device {
      volume_size = var.env=="prd" ? 20 : var.ec2_default_root_volume_size
      volume_type = "gp3"
    }

    tags = {
        Name = each.key
        # Environment = var.env
    }

}

# import from existing instance in AWS
# resource "aws_instance" "my_new_instance" {
#     ami = "unknown"
#     instance_type = "unknown"
# }
# run below command for this terraform import aws_instance.my_new_instance instance-id

