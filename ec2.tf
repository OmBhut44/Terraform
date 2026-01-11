# key pair (login)
resource "aws_key_pair" "my_key" {
    key_name   = "my-key"
    public_key = file("terra-key-ec2.pub")
  
}


# VPC & Security group 

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_security" {
    name = "om-automate-dg"
    description = "this will add an TF generated security group" 
    vpc_id = aws_default_vpc.default.id 

    # inbound rule
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # this is source block
        description = "Om allow SSH from anywhere"
    }

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Om allow HTTP from anywhere"
    }

    ingress {
        from_port = 8000
        to_port   = 8000
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Om allow HTTP from anywhere"
    }
    # outbound rule 
    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1" # all access [port range all]
        cidr_blocks = ["0.0.0.0/0"]
        description = "Om allow all outbound traffic"
    }

    tags = {
        Name = "om-automate-sg"
    }
}

# ec2 instance

resource "aws_instance" "my-instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security.name]
    instance_type = var.ec2_instance_type
    ami = var.ec2_ami_id # ubuntu us-east-2
    user_data = file("install_nginx.sh")
    
    root_block_device {
        volume_size = var.ec2_root_storage_size
        volume_type = "gp3" # general purpose SSD
    }

    tags = {
        Name = "om-automate-instance-beast"
    }
  
}