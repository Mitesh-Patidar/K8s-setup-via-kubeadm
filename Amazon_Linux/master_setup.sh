#!/bin/bash
set -e

# Disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab

# Update and install dependencies
dnf update -y
dnf install -y curl wget tar nano bash-completion --allowerasing

# Load kernel modules
modprobe br_netfilter
modprobe overlay

# Set sysctl params
tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# Verify settings
cat /proc/sys/net/bridge/bridge-nf-call-iptables
cat /proc/sys/net/ipv4/ip_forward

# Install containerd
dnf install -y containerd
systemctl start containerd
systemctl enable containerd

mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml > /dev/null

# Set SystemdCgroup = true automatically
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# Add Kubernetes repo
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

# Install kubelet, kubeadm, kubectl
dnf install -y kubeadm kubelet kubectl --disableexcludes=kubernetes
systemctl enable kubelet

# Initialize Kubernetes master
kubeadm init --pod-network-cidr=192.168.0.0/16

# Set up kubectl config for regular user
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy Calico network plugin
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml

# Show join command again for worker
echo "Worker join command:"
kubeadm token create --print-join-command

