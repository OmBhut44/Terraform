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
    
    # count = 2 # it will create 2 instance but with the same name 

    for_each = tomap({
        om-automate-instance-micro = "t2.micro"
        om-automate-instance-medium = "t2.medium"
    }) # meta argument to create multiple instances with different types

    depends_on = [ aws_security_group.my_security, aws_key_pair.my_key ]

    key_name = aws_key_pair.my_key.key_name

    security_groups = [aws_security_group.my_security.name]    
    
    instance_type = each.value
    
    ami = var.ec2_ami_id # ubuntu us-east-2

    user_data = file("install_nginx.sh") # script to run on instance creation
    root_block_device {
        volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
        volume_type = "gp3" # general purpose SSD
    }

    tags = {
        Name = each.key
    }
  
}

# this is only when you want manually import existing resource into terraform state
# we want to get the data of the resource which is manualy created outside of terraform [direct in aws] 
# resource "aws_instance" "my_new_instance" {
#     ami = "unknown" # invalid argument to demonstrate terraform plan error
#     instance_type = "unknown"
# }