# resource "aws_db_instance" "database-instance" {
#   instance_class = "${var.db-instance}"
#   skip_final_snapshot = true
#   availability_zone = "us-east-1a"
#   identifier = "${var.db-instance-identifier}"
#   snapshot_identifier = data.aws_db_snapshot.latest-db-snapshot.id
#   db_subnet_group_name = element(aws_subnet.private.*.id, count.index)
#   multi_az = true
#   deletion_protection = true
#   vpc_security_group_ids = [aws_security_group.db_sg.id]
# }