resource "aws_mq_broker" "test-mq" {

  #   configuration {
  #     logs = "general"
  #   }

  logs {
    general = true
  }
  count                   = var.az_count
  broker_name             = var.broker_name
  engine_type             = var.broker_engine_type
  engine_version          = var.broker_engine_version
  storage_type            = var.broker_storage_type
  host_instance_type      = var.broker_instance_type
  authentication_strategy = var.broker_auth_strategy
  deployment_mode         = var.broker_deployment_strategy
  #   logs                    = var.broker_logging_strategy
  publicly_accessible = false
  subnet_ids          = [element(aws_subnet.private.*.id, count.index)]
  security_groups     = [aws_security_group.mq_sg.id]

  user {
    username = "ExampleUser"
    password = "MindTheGapFor250Char"
  }
}
