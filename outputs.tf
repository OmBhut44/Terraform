# output for count instances
# output "ec2_public_ip" {
#     value = aws_instance.my-instance[*].public_ip
# }


# output "ec2_public_dns" {
#     value = aws_instance.my-instance[*].public_dns
# }

# output "ec2_private_ip" {
#     value = aws_instance.my-instance[*].private_ip
# }


# output for for_each instances
output "ec2_public_ip" {
    value = [
        for key in aws_instance.my-instance : key.public_ip
    ]
}

output "ec2_public_dns" {
    value = [
        for key in aws_instance.my-instance : key.public_dns
    ]
}

output "ec2_private_ip" {
    value = [
        for key in aws_instance.my-instance : key.private_ip
    ]
}