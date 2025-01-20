#!/bin/bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

sudo yum install docker -y
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker root
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock

docker --version

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
eksctl version

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

# ==============================================================================================================================================

# Cluster
public_a=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=public-a" --query "Subnets[].SubnetId[]" --region ap-northeast-2 --output text)
public_b=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=public-b" --query "Subnets[].SubnetId[]" --region ap-northeast-2 --output text)
public_c=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=public-c" --query "Subnets[].SubnetId[]" --region ap-northeast-2 --output text)
private_a=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=private-a" --query "Subnets[].SubnetId[]" --region ap-northeast-2 --output text)
private_b=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=private-b" --query "Subnets[].SubnetId[]" --region ap-northeast-2 --output text)
private_c=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=private-c" --query "Subnets[].SubnetId[]" --region ap-northeast-2 --output text)

sed -i "s|public_a|$public_a|g" cluster.yaml
sed -i "s|public_b|$public_b|g" cluster.yaml
sed -i "s|public_c|$public_c|g" cluster.yaml
sed -i "s|private_a|$private_a|g" cluster.yaml
sed -i "s|private_b|$private_b|g" cluster.yaml
sed -i "s|private_c|$private_c|g" cluster.yaml

eksctl create cluster -f cluster.yaml
aws eks --region ap-northeast-2 update-kubeconfig --name skills-cluster --alias skills-cluster

helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --set clusterName=skills-cluster \
  -n kube-system \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

# k8s resources
kubectl create ns skills
kubectl apply -f deployment.yaml
sed -i "s|public_a|$public_a|g" service.yaml
sed -i "s|public_b|$public_b|g" service.yaml
sed -i "s|public_c|$public_c|g" service.yaml
kubectl apply -f service.yaml