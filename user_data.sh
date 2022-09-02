#!/bin/bash

# UPDATE AND INSTALL DOCKER:
sudo yum update -y
sudo yum install yum-utils docker -y
sudo usermod -aG docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose &&
sudo chkconfig docker on &&
sudo service docker start &&

# BUILD NEW IMAGE AND RUN CONTAINER:
cd ~
cat <<EOF > Dockerfile
 FROM jenkins/jenkins
 USER root
 RUN apt-get update && apt-get install wget -y

 ### Install Terraform ###
 RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip \
 && unzip terraform_1.0.9_linux_amd64.zip \
 && mv terraform /usr/bin \
 && rm terraform_1.0.9_linux_amd64.zip

 USER jenkins
EOF

sudo docker build -t jenkins-server-image . &&
sudo docker run -d -p 80:8080 --name jenkins-pod jenkins-server-image &&

# CREATE A SYSTEMS MANAGER PARAMETER WITH JENKINS ADMIN PASSWORD:
JENKINS_PASSWORD=$(sudo docker exec -ti jenkins-pod cat /var/jenkins_home/secrets/initialAdminPassword)
aws ssm put-parameter --region us-east-1 --name "JenkinsinitialAdminPassword" --value "$JENKINS_PASSWORD" --type String --overwrite