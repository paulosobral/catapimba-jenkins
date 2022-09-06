#!/bin/bash

# UPDATE AND INSTALL DOCKER:
sudo yum update -y
sudo yum install yum-utils docker -y
sudo usermod -aG docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_instance_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
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
 RUN wget --quiet https://releases.hashicorp.com/terraform/${terraform_jenkins_version}/terraform_${terraform_jenkins_version}_linux_amd64.zip \
 && unzip terraform_${terraform_jenkins_version}_linux_amd64.zip \
 && mv terraform /usr/bin \
 && rm terraform_${terraform_jenkins_version}_linux_amd64.zip

 USER jenkins
EOF

sudo docker build -t jenkins-server-image . &&
sudo docker run -d -p 80:8080 --name jenkins-pod jenkins-server-image &&

sleep 30

# CREATE A SYSTEMS MANAGER PARAMETER WITH JENKINS ADMIN PASSWORD:
aws ssm put-parameter --region us-east-1 --name "JenkinsinitialAdminPassword" --value "$(sudo docker exec jenkins-pod cat /var/jenkins_home/secrets/initialAdminPassword)" --type String --overwrite