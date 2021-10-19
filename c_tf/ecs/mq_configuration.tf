# applies to active mq only
# resource "aws_mq_configuration" "example" {
#   description             = "Example Configuration"
#   name                    = "example"
#   engine_type             = "RabbitMQ"
#   engine_version          = "3.8.22"
#   authentication_strategy = "simple"
#   # logs                    = var.broker_logging_strategy
#   data                    = <<DATA
# <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
# <broker xmlns="http://activemq.apache.org/schema/core">
#   <plugins>
#     <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
#     <statisticsBrokerPlugin/>
#     <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
#   </plugins>
# </broker>
# DATA
# }
