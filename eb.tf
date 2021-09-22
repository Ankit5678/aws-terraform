# Create elastic beanstalk application
resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = var.elasticapp
}

# Create elastic beanstalk Environment
resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = var.beanstalkappenv
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = var.solution_stack_name
  tier                = var.tier
  cname_prefix        = var.dns_prefix

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.vpc.id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     =  "True"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnets)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 2
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

}

resource "aws_elastic_beanstalk_configuration_template" "ElasticBeanstalkConfigurationTemplate" {
  application = var.elastic_beanstalk_app
    solution_stack_name = var.solution_stack_name
    environment_id = var.elastic_beanstalk_appenv
    setting {
        namespace = "aws:autoscaling:asg"
        name = "Availability Zones"
        resource = "AWSEBAutoScalingGroup"
        value = "Any 3"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "Cooldown"
        resource = "AWSEBAutoScalingGroup"
        value = "360"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "Custom Availability Zones"
        resource = "AWSEBAutoScalingGroup"
        value = "us-east-1a,us-east-1b,us-east-1c"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "EnableCapacityRebalancing"
        resource = "AWSEBAutoScalingGroup"
        value = "false"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MaxSize"
        resource = "AWSEBAutoScalingGroup"
        value = "10"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MinSize"
        resource = "AWSEBAutoScalingGroup"
        value = "3"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "BlockDeviceMappings"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "DisableIMDSv1"
        value = "true"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "EC2KeyName"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        resource = "AWSEBEC2LaunchTemplate"
        value = "aws-elasticbeanstalk-ec2-role"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "ImageId"
        resource = "AWSEBEC2LaunchTemplate"
        value = "ami-081e3132ab4de11a6"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "t2.micro"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "MonitoringInterval"
        resource = "AWSEBEC2LaunchTemplate"
        value = "5 minute"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "RootVolumeIOPS"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "RootVolumeSize"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "RootVolumeThroughput"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "RootVolumeType"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "SSHSourceRestriction"
        value = "tcp,22,22,0.0.0.0/0"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "SecurityGroups"
        resource = "AWSEBEC2LaunchTemplate"
        # value = "security-group-for-inbound-nfs-d-pgnc9h3ceagh,security-group-for-outbound-nfs-d-pgnc9h3ceagh,awseb-e-yghitzseka-stack-AWSEBSecurityGroup-1W3NTTKC03O9Q"
        value = "'${aws_security_group.webserver-security-group.id}'"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "BreachDuration"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "1"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "EvaluationPeriods"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "1"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "LowerBreachScaleIncrement"
        resource = "AWSEBAutoScalingScaleDownPolicy"
        value = "-1"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "LowerThreshold"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "20"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "MeasureName"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "RequestCount"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "Period"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "1"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "Statistic"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "Average"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "Unit"
        resource = "AWSEBCloudwatchAlarmLow"
        value = "Count"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "UpperBreachScaleIncrement"
        resource = "AWSEBAutoScalingScaleUpPolicy"
        value = "1"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "UpperThreshold"
        resource = "AWSEBCloudwatchAlarmHigh"
        value = "60"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "MaxBatchSize"
        resource = "AWSEBAutoScalingGroup"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "MinInstancesInService"
        resource = "AWSEBAutoScalingGroup"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "PauseTime"
        resource = "AWSEBAutoScalingGroup"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "RollingUpdateEnabled"
        resource = "AWSEBAutoScalingGroup"
        value = "false"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "RollingUpdateType"
        resource = "AWSEBAutoScalingGroup"
        value = "Time"
    }
    setting {
        namespace = "aws:autoscaling:updatepolicy:rollingupdate"
        name = "Timeout"
        resource = "AWSEBAutoScalingGroup"
        value = "PT30M"
    }
    setting {
        namespace = "aws:cloudformation:template:parameter"
        name = "AppSource"
        value = "https://elasticbeanstalk-platform-assets-us-east-1.s3.amazonaws.com/stalks/eb_docker_amazon_linux_2_1.0.1613.0_20210827230950/sampleapp/EBSampleApp-Docker.zip"
    }
    setting {
        namespace = "aws:cloudformation:template:parameter"
        name = "EnvironmentVariables"
    }
    setting {
        namespace = "aws:cloudformation:template:parameter"
        name = "HooksPkgUrl"
        value = "https://elasticbeanstalk-platform-assets-us-east-1.s3.amazonaws.com/stalks/eb_docker_amazon_linux_2_1.0.1613.0_20210827230950/lib/hooks.tar.gz"
    }
    setting {
        namespace = "aws:cloudformation:template:parameter"
        name = "InstancePort"
        value = "80"
    }
    setting {
        namespace = "aws:cloudformation:template:parameter"
        name = "InstanceTypeFamily"
        value = "t2"
    }
    setting {
        namespace = "aws:ec2:instances"
        name = "EnableSpot"
        value = "false"
    }
    setting {
        namespace = "aws:ec2:instances"
        name = "InstanceTypes"
        value = "t2.micro, t2.small"
    }
    setting {
        namespace = "aws:ec2:instances"
        name = "SpotFleetOnDemandAboveBasePercentage"
        value = "70"
    }
    setting {
        namespace = "aws:ec2:instances"
        name = "SpotFleetOnDemandBase"
        value = "0"
    }
    setting {
        namespace = "aws:ec2:instances"
        name = "SpotMaxPrice"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "AssociatePublicIpAddress"
        resource = "AWSEBEC2LaunchTemplate"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "ELBScheme"
        value = "public"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "ELBSubnets"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "Subnets"
        resource = "AWSEBAutoScalingGroup"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "VPCId"
        resource = "AWSEBLoadBalancerSecurityGroup"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application"
        name = "Application Healthcheck URL"
        value = ""
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "DeleteOnTerminate"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "RetentionInDays"
        value = "30"
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "StreamLogs"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
        name = "DeleteOnTerminate"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
        name = "HealthStreamingEnabled"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
        name = "RetentionInDays"
        value = "30"
    }
    setting {
        namespace = "aws:elasticbeanstalk:command"
        name = "BatchSize"
        value = "30"
    }
    setting {
        namespace = "aws:elasticbeanstalk:command"
        name = "BatchSizeType"
        value = "Percentage"
    }
    setting {
        namespace = "aws:elasticbeanstalk:command"
        name = "DeploymentPolicy"
        value = "Rolling"
    }
    setting {
        namespace = "aws:elasticbeanstalk:command"
        name = "IgnoreHealthCheck"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:command"
        name = "Timeout"
        value = "600"
    }
    setting {
        namespace = "aws:elasticbeanstalk:control"
        name = "DefaultSSHPort"
        value = "22"
    }
    setting {
        namespace = "aws:elasticbeanstalk:control"
        name = "LaunchTimeout"
        value = "0"
    }
    setting {
        namespace = "aws:elasticbeanstalk:control"
        name = "LaunchType"
        value = "Migration"
    }
    setting {
        namespace = "aws:elasticbeanstalk:control"
        name = "RollbackLaunchOnFailure"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "EnvironmentType"
        value = "LoadBalanced"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "ExternalExtensionsS3Bucket"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "ExternalExtensionsS3Key"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "LoadBalancerIsShared"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "LoadBalancerType"
        value = "application"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "ServiceRole"
        value = "arn:aws:iam::324257953347:role/aws-elasticbeanstalk-service-role"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "DeregistrationDelay"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "20"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "HealthCheckInterval"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "15"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "HealthCheckPath"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "/"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "HealthCheckTimeout"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "5"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "HealthyThresholdCount"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "3"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "MatcherHTTPCode"
        resource = "AWSEBV2LoadBalancerTargetGroup"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "Port"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "80"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "Protocol"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "HTTP"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "StickinessEnabled"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "StickinessLBCookieDuration"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "86400"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "StickinessType"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "lb_cookie"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name = "UnhealthyThresholdCount"
        resource = "AWSEBV2LoadBalancerTargetGroup"
        value = "5"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment:proxy"
        name = "ProxyServer"
        value = "nginx"
    }
    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name = "ConfigDocument"
        value = "{\\"Version\\":1,\\"CloudWatchMetrics\\":{\\"Instance\\":{\\"RootFilesystemUtil\\":null,\\"CPUIrq\\":null,\\"LoadAverage5min\\":null,\\"ApplicationRequests5xx\\":null,\\"ApplicationRequests4xx\\":null,\\"CPUUser\\":null,\\"LoadAverage1min\\":60,\\"ApplicationLatencyP50\\":null,\\"CPUIdle\\":null,\\"InstanceHealth\\":null,\\"ApplicationLatencyP95\\":null,\\"ApplicationLatencyP85\\":null,\\"ApplicationLatencyP90\\":null,\\"CPUSystem\\":null,\\"ApplicationLatencyP75\\":null,\\"CPUSoftirq\\":null,\\"ApplicationLatencyP10\\":null,\\"ApplicationLatencyP99\\":null,\\"ApplicationRequestsTotal\\":null,\\"ApplicationLatencyP99.9\\":null,\\"ApplicationRequests3xx\\":null,\\"ApplicationRequests2xx\\":null,\\"CPUIowait\\":null,\\"CPUNice\\":null},\\"Environment\\":{\\"InstancesSevere\\":null,\\"InstancesDegraded\\":null,\\"ApplicationRequests5xx\\":null,\\"ApplicationRequests4xx\\":null,\\"ApplicationLatencyP50\\":null,\\"ApplicationLatencyP95\\":null,\\"ApplicationLatencyP85\\":null,\\"InstancesUnknown\\":null,\\"ApplicationLatencyP90\\":null,\\"InstancesInfo\\":null,\\"InstancesPending\\":null,\\"ApplicationLatencyP75\\":null,\\"ApplicationLatencyP10\\":null,\\"ApplicationLatencyP99\\":null,\\"ApplicationRequestsTotal\\":null,\\"InstancesNoData\\":null,\\"ApplicationLatencyP99.9\\":null,\\"ApplicationRequests3xx\\":null,\\"ApplicationRequests2xx\\":null,\\"InstancesOk\\":60,\\"InstancesWarning\\":null}},\\"Rules\\":{\\"Environment\\":{\\"ELB\\":{\\"ELBRequests4xx\\":{\\"Enabled\\":false}},\\"Application\\":{\\"ApplicationRequests4xx\\":{\\"Enabled\\":false}}}}}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name = "EnhancedHealthAuthEnabled"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name = "HealthCheckSuccessThreshold"
        value = "Ok"
    }
    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name = "SystemType"
        value = "enhanced"
    }
    setting {
        namespace = "aws:elasticbeanstalk:hostmanager"
        name = "LogPublicationControl"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name = "ManagedActionsEnabled"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name = "PreferredStartTime"
        value = "Wed:04:00"
    }
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name = "ServiceRoleForManagedUpdates"
        value = "arn:aws:iam::324257953347:role/aws-elasticbeanstalk-service-role"
    }
    setting {
        namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
        name = "InstanceRefreshEnabled"
        value = "false"
    }
    setting {
        namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
        name = "UpdateLevel"
        value = "minor"
    }
    setting {
        namespace = "aws:elasticbeanstalk:monitoring"
        name = "Automatically Terminate Unhealthy Instances"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:sns:topics"
        name = "Notification Endpoint"
        value = "abc@example.com"
    }
    setting {
        namespace = "aws:elasticbeanstalk:sns:topics"
        name = "Notification Protocol"
        value = "email"
    }
    setting {
        namespace = "aws:elasticbeanstalk:sns:topics"
        name = "Notification Topic ARN"
        value = "arn:aws:sns:us-east-1:324257953347:ElasticBeanstalkNotifications-Environment-Demoeb-env"
    }
    setting {
        namespace = "aws:elasticbeanstalk:sns:topics"
        name = "Notification Topic Name"
    }
    setting {
        namespace = "aws:elasticbeanstalk:trafficsplitting"
        name = "EvaluationTime"
    }
    setting {
        namespace = "aws:elasticbeanstalk:trafficsplitting"
        name = "NewVersionPercent"
    }
    setting {
        namespace = "aws:elasticbeanstalk:xray"
        name = "XRayEnabled"
        value = "true"
    }
    setting {
        namespace = "aws:elbv2:listener:default"
        name = "DefaultProcess"
        resource = "AWSEBV2LoadBalancerListener"
        value = "default"
    }
    setting {
        namespace = "aws:elbv2:listener:default"
        name = "ListenerEnabled"
        resource = "AWSEBV2LoadBalancerListener"
        value = "true"
    }
    setting {
        namespace = "aws:elbv2:listener:default"
        name = "Protocol"
        resource = "AWSEBV2LoadBalancerListener"
        value = "HTTP"
    }
    setting {
        namespace = "aws:elbv2:listener:default"
        name = "Rules"
        resource = "AWSEBV2LoadBalancerListener"
    }
    setting {
        namespace = "aws:elbv2:listener:default"
        name = "SSLCertificateArns"
        resource = "AWSEBV2LoadBalancerListener"
    }
    setting {
        namespace = "aws:elbv2:listener:default"
        name = "SSLPolicy"
        resource = "AWSEBV2LoadBalancerListener"
    }
    setting {
        namespace = "aws:elbv2:loadbalancer"
        name = "AccessLogsS3Bucket"
        resource = "AWSEBV2LoadBalancer"
        value = "eb-test-001"
    }
    setting {
        namespace = "aws:elbv2:loadbalancer"
        name = "AccessLogsS3Enabled"
        resource = "AWSEBV2LoadBalancer"
        value = "true"
    }
    setting {
        namespace = "aws:elbv2:loadbalancer"
        name = "AccessLogsS3Prefix"
        resource = "AWSEBV2LoadBalancer"
        value = "ALB/"
    }
    setting {
        namespace = "aws:elbv2:loadbalancer"
        name = "IdleTimeout"
        resource = "AWSEBV2LoadBalancer"
    }
    setting {
        namespace = "aws:elbv2:loadbalancer"
        name = "SecurityGroups"
        resource = "AWSEBV2LoadBalancer"
        value = "${aws_security_group.EC2SecurityGroup.id}"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBAllocatedStorage"
        resource = "AWSEBRDSDatabase"
        value = "5"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBDeletionPolicy"
        resource = "AWSEBRDSDatabase"
        value = "Snapshot"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBEngine"
        resource = "AWSEBRDSDatabase"
        value = "mysql"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBEngineVersion"
        resource = "AWSEBRDSDatabase"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBInstanceClass"
        resource = "AWSEBRDSDatabase"
        value = "db.t2.micro"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBPassword"
        value = "******"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBSnapshotIdentifier"
        resource = "AWSEBRDSDatabase"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "DBUser"
        value = "admin"
    }
    setting {
        namespace = "aws:rds:dbinstance"
        name = "MultiAZDatabase"
        resource = "AWSEBRDSDatabase"
        value = "true"
    }
}