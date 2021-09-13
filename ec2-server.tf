# #create EC2 instance
# resource "aws_instance" "ec2-web-instance-1" {
#   ami                    = "${var.my_ami_image}"
#   instance_type          = "t2.micro"
#   key_name               = "<your_private_key>" #make sure you have your_private_ket.pem file
#   vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]
#   subnet_id              = "${aws_subnet.public-subnet-1}"
#   tags = {
#     Name = "tf-test-ec2-web-instance"
#   }
#   volume_tags = {
#     Name = "tf-test-ec2-web-instance-volume"
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo mkdir -p /var/www/html/",
#       "sudo yum update -y",
#       "sudo yum install -y httpd",
#       "sudo service httpd start",
#       "sudo usermod -a -G apache ec2-user",
#       "sudo chown -R ec2-user:apache /var/www",
#       "sudo yum install -y mysql php php-mysql"
#     ]
#   }
# #   provisioner "file" {
# #     source      = "index.php"
# #     destination = "/var/www/html/index.php"
# #   }
#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = ""
#     #copy <your_private_key>.pem to your local instance home directory
#     #restrict permission: chmod 400 <your_private_key>.pem
#     private_key = file("/home/ec2-user/<your_private_key>.pem")
#   }
# }

# resource "aws_instance" "ec2-web-instance-2" {
#   ami                    = "${var.my_ami_image}"
#   instance_type          = "t2.micro"
#   key_name               = "<your_private_key>" #make sure you have your_private_ket.pem file
#   vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]
#   subnet_id              = "${aws_subnet.public-subnet-2}"
#   tags = {
#     Name = "tf-test-ec2-web-instance"
#   }
#   volume_tags = {
#     Name = "tf-test-ec2-web-instance-volume"
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo mkdir -p /var/www/html/",
#       "sudo yum update -y",
#       "sudo yum install -y httpd",
#       "sudo service httpd start",
#       "sudo usermod -a -G apache ec2-user",
#       "sudo chown -R ec2-user:apache /var/www",
#       "sudo yum install -y mysql php php-mysql"
#     ]
#   }
# #   provisioner "file" {
# #     source      = "index.php"
# #     destination = "/var/www/html/index.php"
# #   }
#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     password = ""
#     #copy <your_private_key>.pem to your local instance home directory
#     #restrict permission: chmod 400 <your_private_key>.pem
#     private_key = file("/home/ec2-user/<your_private_key>.pem")
#   }
# }
