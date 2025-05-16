#  Kubernetes Cluster Setup Scripts (Master & Worker)

This repository contains **Bash scripts to automate the setup of a Kubernetes cluster**

The scripts help you install and configure:
- containerd
- kubeadm, kubelet, kubectl
- Kernel modules and sysctl settings
- Calico CNI (on master)
- Cluster initialization and join (via token)

---

##  Prerequisites

Please complete the following **on both master and worker nodes** before running the setup scripts.

###  1. Open Required Ports

Ensure the following **TCP ports** are open in your cloud firewall/security group:

| Port(s)        | Purpose                                              |
|----------------|------------------------------------------------------|
| 6443           | Kubernetes API server                                 |
| 2379-2380      | etcd server client API                                |
| 10250-10252    | Kubelet & control plane communication                 |
| 10255          | Read-only Kubelet API (optional, used by some tools) |
| 30000-32767    | NodePort Services                                     |

###  2. Set Hostnames

On the **master node**:
```bash
sudo hostnamectl set-hostname master
```
On the worker node:
```bash
sudo hostnamectl set-hostname worker
```
### 3. Update /etc/hosts File
On both nodes, run the following lines (replace IPs accordingly):
```bash
echo "<private_ip_of_master> master" | sudo tee -a /etc/hosts
echo "<private_ip_of_worker> worker" | sudo tee -a /etc/hosts
```
Replace <private_ip_of_master> and <private_ip_of_worker> with actual private IPs.

### 4. System Update & Upgrade
```bash
sudo apt update && sudo apt upgrade -y
```
### 5. Reboot
Apply changes by rebooting:
```bash
sudo reboot
```
 Note: On cloud servers like AWS, rebooting will disconnect your SSH session. You will need to reconnect using your PEM file or credentials. In production, ensure reboots do not disrupt live services.
##
### Important Note on `sudo reboot`

This guide includes a `sudo reboot` command to apply updates and hostname changes. Please be aware of the following:

- On **cloud platforms like AWS**, `sudo reboot` will **not delete** your server, but it will **temporarily disconnect your SSH session**. You will need to **SSH again after the instance restarts**.
- In **production environments**, rebooting a node may impact running workloads or critical services.
  - Ensure reboots are done during maintenance windows or in coordination with your DevOps team.
  - In real production clusters, node reboots are typically handled via automated orchestration tools with proper draining and safety mechanisms.

 Only run `sudo reboot` if you fully understand the impact in your specific environment.

###  Contributing
Feel free to fork, modify, and open pull requests to improve or extend the setup.

