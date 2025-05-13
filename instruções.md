# Instalar e configurar as ferramentas necessárias
## Docker Desktop
* Baixe e instale o Docker Desktop em [www.docker.com](https://www.docker.com/).
* Após instalar, reinicie o computador se solicitado.
## AWS CLI
* Baixe o instalador oficial do AWS CLI em [docs.aws.amazon.com](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
* Após instalar, abra o Prompt de Comando (cmd) ou PowerShell e execute:
```bash
aws --version
```
Deve aparecer a versão instalada.

## Configurar AWS CLI
* No terminal, rode:
```bash
aws configure
```
Forneça as credenciais (Access Key, Secret Key), região (us-east-1 é uma boa escolha para o free tier) e formato (json).

# Preparar as imagens Docker
No Prompt de Comando ou PowerShell:

* No diretório do seu docker-compose.yml, rode:
```bash
docker build -t portfolio-server:0.0.2-SNAPSHOT .
```
* No diretório do portfolio-app:
```bash
docker build -t portfolio-app:0.0.3-SNAPSHOT ../portfolio-app
```
# Subir as imagens para o Amazon ECR
## Crie os repositórios no ECR
* No console.aws.amazon.com, procure por ECR e crie dois repositórios privados:
  * portfolio-server
  * portfolio-app
## Faça login no ECR
No terminal, rode:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 245128127349.dkr.ecr.us-east-1.amazonaws.com
```
Substitua `<ACCOUNT_ID>` pelo número da sua conta AWS (aparece no canto superior direito do console AWS).

## Tagueie as imagens

```bash
docker tag portfolio-server:0.0.2-SNAPSHOT 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-server:latest
docker tag portfolio-app:0.0.3-SNAPSHOT 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app:latest
```

## Envie as imagens para o ECR
```bash
docker push 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-server:latest
docker push 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app:latest
```
# Criar o cluster ECS Fargate e publicar a aplicação
Esses passos são feitos pelo console web da AWS (mais fácil para iniciantes):

## Criar cluster
* No AWS Console, vá em ECS > Clusters > Create Cluster > escolha "Networking only (Fargate)".
* Dê um nome, ex: portfolio-cluster.
Avance, usando as configurações padrão.

## Criar Task Definition
* Em Task Definitions > Create new Task Definition > Fargate.
* Nome: portfolio-task.
* Task memory: 1GB, CPU: 0.5 vCPU.
* Adicione os dois containers:
* **portfolio-server**
  * Image: `245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-server:latest`
  * Port: 3000
* **portfolio-app**
  * Image: `245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app:latest`
  * Port: 80
  * Environment: API_URL=http://localhost:3000

## Criar Serviço
* No cluster criado, clique em Create > Create Service.
* Escolha a task definition criada.
    Tipo: Fargate.
    Número de tasks: 1.
* Escolha uma VPC e subnets públicas.
* Crie um Security Group liberando porta 80 (HTTP) para acesso externo.

## Liberar portas no Security Group
* No console AWS, vá em EC2 > Security Groups.
* Encontre o grupo associado ao seu serviço ECS.
* Edite as regras de entrada:
  * Libere a porta 80 (HTTP) para 0.0.0.0/0 (ou apenas para seu IP, se preferir mais seguro).


# Acesse sua aplicação
* No ECS, veja o endpoint público da task (ou o IP público).
* Acesse pelo navegador:
```
http://245128127349.dkr.ecr.us-east-1.amazonaws.com
```

# Dicas para Windows
* Use sempre Prompt de Comando ou PowerShell (não o terminal do WSL, a menos que esteja confortável com Linux).
* Se tiver problemas de permissão, execute o terminal como Administrador.
* Os comandos Docker e AWS CLI funcionam normalmente no Windows.


# Observações Finais
* Free Tier: Fique atento ao uso para não gerar custos.
* Encerramento: Quando não estiver usando, delete o serviço, cluster e imagens do ECR.
* Documentação oficial:

```
docs.aws.amazon.com