# DevOps

**Nesse tutorial, irei mostrar como criar uma pipeline no jenkins para iniciar o job de criação da infraestrutura na Google Cloud Platform usando terraform e salvando o arquivo tfstat em um bucket.**


![infra](https://user-images.githubusercontent.com/97743829/175945901-dcb02abf-c3cf-41e3-8ba4-d66d4d7ebfb4.JPG)
A imagem acima mostra o processo de criação da infraestrutura (vm + bucket) através do job Terraform_pipeline e também sua remoção através do job Terraform_destroy (exceto o bucket).

**Requisitos:**
- 1 - Host com VSCode + GitBash instalado.
- 2 - VM ou Servidor com o terraform + Jenkins + Git instalados (aqui usei uma VM com Debian 11 hospedado na própria GCP).
- 3 - Conta no Google Cloud Platform.

**Configurando o projeto GitHub:**

No seu perfil do GitHub, navegue até "settings", escolha "developer settings", depois "personal access token" e clique em "create access token" 
Anote esse token, ele será usado mais para frente.

**Configurar o git na máquina que o Jenkins está instalado:**

```
git config --global user.name "Seu nome sem aspas"
git config --global user.email "Seu e-mail sem aspas"

Para validar:
git config --list

git clone linkdoseurepo.git
o console irá pedir seu usuário e senha.

```

**Integrar o Jenkins ao GitHub:**

Antes de tudo, você terá que inserir as credentials criadas na etapa anteriro.
Ir até o Jenkins > Projeto > add credentials > colocar seu username do GIT e o token de acesso criado anteriormente.

- a. Ir ao seu repositório no GitHub que quer integrar.
- b. Clicar em Settings
- c. Clicar em webhooks > add webhooks
- d. Em payload, insira a url completa do jenkins adicionando no final "/github-webhook/" ex utilizado: "http://34.125.192.189:8080/github-webhook/" 
e em "Content type" selecione "application/json", deixe "secret" em branco.
- e. Escolha a opção "Let me select individual events." selecione "Pull requests", "push" e "active" depois clique em "add webhook"
- f. Volte ao Jenkins e clique em "new item" > digite um nome e selecione "freestyle project"  e clique em "ok"
na tela seguinte selecione a aba  "Source Code Management" > marque a checkbox "git" e cole o código copiado do repositório ex: "https://github.com/LGbasilio/DevOps.git"
- g. Clique em "Build Triggers" e selecione "GitHub hook trigger for GITScm polling" e em "Branch Specifier (blank for 'any')" mudar de "master" para "main"

* Pronto! Seu repositório está integrado ao git.

**Startando uma trigger no jenkins para testes:**

- a. Clique na aba "Build Env" mude "Add build step" para "Execute shell" digite algum comando do bash, ex: "ps -ef".
- b. Clique em Save.
- c. Clique em build, se tiver tudo certo o Jenkins ira mostrar todos os passos executados e no final terá a saída do comando "ps -ef"

**Configurando Terraform no Jenkins:**

Na página inicial clicar em gerir Jenkins > plugin > procurar teraform > clicar em instalar.

Depois gerir jenkins novamente > Global tools configuration > add terraform > setar um nome de sua preferência > tirar a flag de atualizações automáticas >
install directory digitar "/usr/bin" > save


Inserir o script de pipeline:

Terraform APPLY script Jenkins
```

pipeline {
    agent any
    tools {
       terraform 'terraform'
    }
    stages {
        stage('Git checkout') {
           steps{
                git branch: 'main', credentialsId: '856172ba-cb78-43c1-aa97-b776cd557998', url: 'https://github.com/LGbasilio/DevOps.git'
            }
        }
        stage('Criação do Bucket') {
            steps{
                sh  '''
                cd bucket
                terraform init
                terraform apply --auto-approve
                cd ..
                    '''
            }
        }
        stage('terraform Init') {
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform apply') {
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
    }

    
}
```
Terraform DESTROY script Jenkins

```


pipeline {
    agent any
    tools {
       terraform 'terraform'
    }
    stages {
        stage('Git checkout') {
           steps{
                git branch: 'main', credentialsId: '856172ba-cb78-43c1-aa97-b776cd557998', url: 'https://github.com/LGbasilio/DevOps.git'
            }
        }
        stage('terraform format init') {
            steps{
                sh 'terraform init'
                
            }
        }
        stage('terraform Destroy') {
            steps{
                sh 'terraform destroy --auto-approve'
            }
        }
        stage('Bucket destroy') {
            steps{
                sh  '''
                cd bucket
                terraform init
                terraform destroy --auto-approve
                    '''
            }
        }
    }

    
}
```





 
