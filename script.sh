#!/bin/bash

# Disable swap
sudo swapoff -a

# Install Docker
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y \
	docker-ce=5:18.09.0~3-0~ubuntu-bionic \
	docker-ce-cli=5:18.09.0~3-0~ubuntu-bionic containerd.io

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker
systemctl daemon-reload
systemctl restart docker

# Install kubectl, kubeadm
sudo apt-get update && sudo apt-get install -y sudo apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

if [ "$HOSTNAME" = "master" ]; then
  kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address `ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
  mkdir -p "$HOME/.kube"
  sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
  sudo chown $(id -u):$(id -g) "$HOME/.kube/config"
  kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
  echo `kubeadm token create --print-join-command` > /tmp/join.sh
  apt install bash-completion -y
  kubectl completion bash > /etc/bash_completion.d/kubectl && exec bash --login
else
  sudo apt install sshpass -y
  sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@192.100.50.200:/tmp/join.sh . && sudo chmod +x join.sh && sudo sh join.sh
fi 
