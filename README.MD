## Elephant Mini Project
Elephant Mini Project is a project that demonstrates how to build and deploy infrastructure/code within a single click.

## Prerequisites
- [Terraform v0.12.20](https://www.hashicorp.com/products/terraform)
- [Packer 1.5.1](https://packer.io/intro/getting-started/build-image.html)
- [Node v10.13.0](https://nodejs.org/en/)
- Npm 6.12.0
- linux environment
- git
- AWS Account with programmatic access
    - Account should have the ability to spin up and destroy EC2 instances
    - Account should have the ability to attach public keys to EC2 instances
    - Account should have the ability to create and destroy ELB instances
    - Account should have the ability to modify launch configurations
    - Account should have the ability to modify security groups for ec2 instances
    - Account should have the ability to modify security groups for elb instances
    - Account should have the ability to modify auto scaling groups
    - Account should have the ability to register AMIs
    - Account should have the ability to create Elastic Block Storage Snapshots
    - Account should run aws configure prior to running script

## Main Players
- Node: To build a basic angular application. Page body should contain 'Automation for the People' and browser tab should contain 'Elephant-Mini-Project'
- Npm: Manage our node dependencies
- Packer: Builds custom image with embedded angular application and environment setup
- Terraform: Infrastructure as code tool, defines what resources the environment needs and how they should interract with the world. Uses Packer ami-image
- Shell Script: Automates the flow of the infrastructure and code deployment

## Run Project:
```./deploy.sh```


## Flow of shell script:

1) set -ex flags so that our script is verbose and fails as soon as an error occurs
2) use npm to install our angular cli and package modules
3) build the application using ng which is obtained from the angular cli module
4) run the application tests to ensure application is properly working prior to packaging
5) once application is properly built and test pass, proceed with packaging the packer file
6) parse packer build output for the specific ami-image id and export it
7) use sed to replace the current ami-image in the terraform file with the new one recently created
8) execute terraform apply to provision aws infrastructure, passing newly built image to the ec2 instances created

## Cleaning up
1) Run Terraform destroy and accept once you are ready
```terraform destroy```

2) deregister your AMI record [here](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Images:sort=name)

3) delete your AMI snapshot [here](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Snapshots:sort=snapshotId)

### Sources
A great article on how we can terraform
https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180

Using packer to build an image
https://packer.io/intro/getting-started/build-image.html

Using nginx to server your angular application
https://medium.com/@hmurari/serving-angular-app-from-behind-a-nginx-web-server-3579df0b04b1
 