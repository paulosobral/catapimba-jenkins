# Catapimba Corps

## Catapimba Jenkins

### Dependências

1. Criar um bucket s3 na AWS manualmente com o nome descrito no arquivo `backend.tf` (ex: `terraform-state-psobral89`);
2. Executar o comando `terraform apply --auto-approve` no projeto que cria a rede no repositório `https://github.com/paulosobral/catapimba-network`;

### Configuração inicial:

1. Acessar a máquina via ssm e criar o arquivo Dockerfile via shell:

```
FROM jenkins/jenkins

USER root

RUN apt-get update && apt-get install wget -y

### Install Terraform ###
RUN wget --quiet https://releases.hashicorp.com/terraform/1.0.9/terraform_1.0.9_linux_amd64.zip \
&& unzip terraform_1.0.9_linux_amd64.zip \
&& mv terraform /usr/bin \
&& rm terraform_1.0.9_linux_amd64.zip

USER jenkins
```

2. Após criar o arquivo, realizar o build da imagem via shell: `docker build -t jenkins-server-image .`;
3. Subir o container com a nova imagem via shell: `docker run -d -p 80:8080 --name jenkins-pod jenkins-server-image`;
4. Acessar o Elastic IP da instância que saiu no output do Terraform (ex: `http://44.206.118.193/`);
5. Recuperar a senha do Jenkins executando o comando via shell: `docker exec -ti jenkins-pod cat /var/jenkins_home/secrets/initialAdminPassword`;
6. Configurar o Jenkins e criar um job do tipo pipeline com o nome `Catapimba Infrastructure`, marcar a opção para habilitar o GitHub Webhooks e utilizar o script:

```
pipeline {
agent any
  stages {
    stage('Clone') {
      steps {
        git url: 'https://github.com/paulosobral/catapimba-network.git', branch: 'main'
      }
    }

    stage('TF Init&Plan') {
      steps {
        script {
          sh 'terraform init'
          sh 'terraform plan -out=myplan.out'
        }
      }
    }

    stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Deseja alterar a Infraestrutura?', description: 'Acao ', name: 'Confirm')
        }
      }
    }

    stage('TF Apply') {
      steps {
          sh 'terraform apply myplan.out'
      }
    }
  }
}
```
7. Configurar no repo GitHub o Webhook para o endereço do Jenkins (ex: `http://44.206.118.193/github-webhook/`);