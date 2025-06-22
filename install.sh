#!/bin/bash

#check whether root user or not.
if [[ $EUID -ne 0 ]] ; then
 echo -e "\e[31m please run the script as root or use sudo .\e[0m]"
 exit 1
fi

#color for message
R="\e[31m"
N="\e[0m"

# install docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
echo -e "$R Logout and Login again $N"

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl

# install eksctl
PLATFORM=$(uname_s)_amd64
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp 
rm eksctl_$PLATFORM.tar.gz
mv /tmp/eksctl /usr/local/bin
