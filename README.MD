# Catapimba Corps

## Catapimba Jenkins

### Dependências

1. Criar um bucket s3 na AWS manualmente com o nome descrito no arquivo `backend.tf` (ex: `terraform-state-psobral89`);
2. Executar o comando `terraform apply --auto-approve` no projeto que cria a rede no repositório `https://github.com/paulosobral/catapimba-network`;

### Configuração inicial:

1. Executar o comando `terraform apply --auto-approve` no projeto;
2. Acessar o Elastic IP da instância que saiu no output `jenkins_aws_elastic_ip` do Terraform (ex: `http://44.206.118.193`). OBS: Este passo pode demorar para carregar a tela de configuração do Jenkins;
3. Recuperar a senha de administrador do Jenkins acessando o serviço AWS Systems Manager > Repositório de parâmetros > JenkinsinitialAdminPassword. OBS: Este passo pode demorar para criar o parâmetro;
4. Configurar o Jenkins utilizando a senha de administrador e criar um job do tipo pipeline com o nome `Catapimba Infrastructure`, marcar a opção para habilitar a opção `GitHub hook trigger for GITScm polling` e utilizar o script:

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
5. Configurar no repo GitHub https://github.com/paulosobral/catapimba-network que vai acionar o Jenkins o Webhook (no repo, Settings -> Webhooks -> Add webhook) para o endereço do Jenkins(ex: `http://44.206.118.193/github-webhook/`);