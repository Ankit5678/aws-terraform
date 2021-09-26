**Settings (load balanced)**

- **Load balancer visibility** – Private
- **Load balancer subnets** – Both private subnets
- **Instance public IP** – Disabled
- **Instance subnets** – Both private subnets
- **Instance security groups** – Add the default security group

For internal applications that shouldn't have access from the internet, you can run everything in private subnets and configure the load balancer to be internally facing (change **Load balancer visibility** to **Internal**). This template creates a VPC with no public subnets and no internet gateway. Use this layout for applications that should only be accessible from the same VPC or an attached VPN.

### Running an Elastic Beanstalk environment in a private VPC

When you create your Elastic Beanstalk environment in a private VPC, the environment doesn't have access to the internet. Your application might need access to the Elastic Beanstalk service or other services. Your environment might use enhanced health reporting, and in this case the environment instances send health information to the enhanced health service. And Elastic Beanstalk code on environment instances sends traffic to other AWS services, and other traffic to non-AWS endpoints (for example, to download dependency packages for your application). Here are some steps you might need to take in this case to ensure that your environment works properly.

- *Configure VPC endpoints for Elastic Beanstalk* – Elastic Beanstalk and its enhanced health service support VPC endpoints, which ensure that traffic to these services stays inside the Amazon network and doesn't require internet access. For more information, see [Using Elastic Beanstalk with VPC endpoints](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/vpc-vpce.html).

- *Configure VPC endpoints for additional services* – Elastic Beanstalk instances send traffic to several other AWS services on your behalf: Amazon Simple Storage Service (Amazon S3), Amazon Simple Queue Service (Amazon SQS), AWS CloudFormation, and Amazon CloudWatch Logs. You must configure VPC endpoints for these services too. For detailed information about VPC endpoints, including per-service links, see [VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) in the *Amazon VPC User Guide*.

  **Note**

  Some AWS services, including Elastic Beanstalk, support VPC endpoints in a limited number of AWS Regions. When you design your private VPC solution, verify that Elastic Beanstalk and the other dependent services mentioned here support VPC endpoints in the AWS Region that you choose.

- *Provide a private Docker image* – In a [Docker](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker.html) environment, code on the environment's instances might try to pull your configured Docker image from the internet during environment creation and fail. To avoid this failure, [build a custom Docker image](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/single-container-docker-configuration.html#single-container-docker-configuration.dockerfile) on your environment, or use a Docker image stored in [Amazon Elastic Container Registry](https://docs.aws.amazon.com/AmazonECR/latest/userguide/) (Amazon ECR) and [configure a VPC endpoint for the Amazon ECR service](https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html).

- *Enable DNS names* – Elastic Beanstalk code on environment instances sends traffic to all AWS services using their public endpoints. To ensure that this traffic goes through, choose the **Enable DNS name** option when you configure all interface VPC endpoints. This adds a DNS entry in your VPC that maps the public service endpoint to the interface VPC endpoint.

  **Important**

  If your VPC isn't private and has public internet access, and if **Enable DNS name** is disabled for any VPC endpoint, traffic to the respective service travels through the public internet. This is probably not what you intend. It's easy to detect this issue with a private VPC, because it prevents this traffic from going through and you receive errors. However, with a public facing VPC, you get no indication.

- *Include application dependencies* – If your application has dependencies such as language runtime packages, it might try to download and install them from the internet during environment creation and fail. To avoid this failure, include all dependency packages in your application's source bundle.

- *Use a current platform version* – Be sure that your environment uses a platform version that was released on February 24, 2020 or later. Specifically, use a platform version that was released in or after one of these two updates: [Linux Update 2020-02-28](https://docs.aws.amazon.com/elasticbeanstalk/latest/relnotes/release-2020-02-28-linux.html), [Windows Update 2020-02-24](https://docs.aws.amazon.com/elasticbeanstalk/latest/relnotes/release-2020-02-24-windows.html).


aws terraform - Google Search
https://www.google.com/search?q=aws+terraform&rlz=1C1ONGR_enIN965IN965&oq=aws+terraform&aqs=chrome..69i57j0i512l4j69i60l3.4064j0j7&sourceid=chrome&ie=UTF-8

(398) Terraform Course - Automate your AWS cloud infrastructure - YouTube
https://www.youtube.com/watch?v=SLB_c_ayRMo

Example: Launching an Elastic Beanstalk in a VPC with Amazon RDS - AWS Elastic Beanstalk
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/vpc-rds.html

Using Elastic Beanstalk with Amazon VPC - AWS Elastic Beanstalk
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/vpc.html

elastic-beanstalk-samples/vpc-private.yaml at master · awsdocs/elastic-beanstalk-samples
https://github.com/awsdocs/elastic-beanstalk-samples/blob/master/cfn-templates/vpc-private.yaml

Amazon ECR interface VPC endpoints (AWS PrivateLink) - Amazon ECR
https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html

aws_elastic_beanstalk_configuration_template | Resources | hashicorp/aws | Terraform Registry
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_configuration_template

General options for all environments - AWS Elastic Beanstalk
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html

General options for all environments - AWS Elastic Beanstalk
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkenvironment

aws_iam_role_policy | Resources | hashicorp/aws | Terraform Registry
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy

aws_iam_role | Resources | hashicorp/aws | Terraform Registry
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

aws_iam_role_policy_attachment | Resources | hashicorp/aws | Terraform Registry
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

aws_iam_instance_profile | Resources | hashicorp/aws | Terraform Registry
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile

Amazon Web Services Sign-In
https://signin.aws.amazon.com/signin?redirect_uri=https%3A%2F%2Fconsole.aws.amazon.com%2Felasticbeanstalk%2Fhome%3Fregion%3Dus-east-1%26state%3DhashArgs%2523%252Fenvironments%26isauthcode%3Dtrue&client_id=arn%3Aaws%3Aiam%3A%3A015428540659%3Auser%2Felasticbeanstalk&forceMobileApp=0&code_challenge=xn1Xfoz8TttqCghY9rEVJRvxxc5caa3PiBvuBoEL358&code_challenge_method=SHA-256

deploy docker image from ecr to elastic beanstalk - Google Search
https://www.google.com/search?q=deploy+docker+image+from+ecr+to+elastic+beanstalk&rlz=1C1ONGR_enIN965IN965&oq=deploy+a+docker+image+from+ecr+to+&aqs=chrome.3.69i57j0i22i30l5.21482j0j7&sourceid=chrome&ie=UTF-8

Using AWS EC2 Container Registry to host Docker images for deployment with Elastic Beanstalk | by Sharetribe | Better sharing | Medium
https://medium.com/bettersharing/using-aws-ec2-container-registry-to-host-docker-images-for-deployment-with-elastic-beanstalk-b5f21c3c8e21