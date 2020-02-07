Prerequisites
- Terraform
- Packer
- Node
- Npm
- linux environment
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

Main Players
- Node: To build basic angular application. Body should contain 'Automation for the People' and browser bar should contain 'Elephant-Mini-Project'
- Npm: Manage out node dependencies
- Packer: Build custom image with embedded angular application and environment setup
- Terraform: Infrastructure as code tool, defines what resources my environment needs and how they should interract with the world. Uses our Packer ami-image
- Shell Script: Automates the flow with a single script

Run Project:
./deploy.sh


Flow:

1) set -ex flags so that our script is verbose and it fails as soon as soon as an error occurs
2) use npm to install our angular cli and package modules so that we may proceed to build our application
3) build our application using ng which we obtained from the angular cli module
4) run our application tests to 