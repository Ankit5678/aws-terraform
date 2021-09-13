# Create Database Subnet Group
# terraform aws db subnet group
resource "aws_db_subnet_group" "database-subnet-group" {
  name = "db subnets"
  subnet_ids = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description = "Subnet defined for db instance"

  tags = {
    Name = "tf-test-db-subnet-group"
  }
}

# Get the Latest DB Snapshot
# terraform aws data db snapshot
data "aws_db_snapshot" "latest-db-snapshot" {
  db_snapshot_identifier = "${var.db-snapshot-identifier}"
  most_recent = true
  snapshot_type = "manual"
}

# Create Database Instance Restored from DB Snapshots
# terraform aws db instance
resource "aws_db_instance" "database-instance" {
  instance_class = "${var.db-instance}"
  skip_final_snapshot = true
  availability_zone = "us-east-1a"
  identifier = "${var.db-instance-identifier}"
  snapshot_identifier = data.aws_db_snapshot.latest-db-snapshot.id
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
  multi_az = "${var.multi-az-deploy}"
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
}