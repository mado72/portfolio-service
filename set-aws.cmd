Set-Alias -Name aws -Value c:\Users\MarceloDamasceno\awscli\Amazon\AWSCLIV2\aws

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 245128127349.dkr.ecr.us-east-1.amazonaws.com

docker buildx build --build-arg NGINX_CONF=nginx.aws.conf -t 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/app:latest .

docker buildx build -t 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/server:latest .

docker push 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/app:latest

docker push 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/server:latest

# docker tag portfolio-app:0.0.4-SNAPSHOT 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/app:latest
# docker tag portfolio-server:0.0.2-SNAPSHOT 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/server:latest
# docker push 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/app:latest
# docker push 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/server:latest

# 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/server
# 245128127349.dkr.ecr.us-east-1.amazonaws.com/portfolio-app/app
