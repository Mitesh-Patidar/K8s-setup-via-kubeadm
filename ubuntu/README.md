# Ubuntu Node Setup Scripts

## ⚠️  IMPORTANT:
### Before running this script, please ensure you have followed all prerequisites
### mentioned in the README file located in the `origin` branch of this repository.
#
#### This README includes essential pre-setup steps like:
#### - Opening required ports
#### - Setting hostnames and updating /etc/hosts
#### - Performing system updates
#### - Rebooting the instance
#
#### These steps apply to setups on Ubuntu, Amazon Linux, and RHEL.
#### Script folders are OS-specific (e.g., `ubuntu/`, `rhel/`, etc.).
#
#### 📄 Refer to the README in the `origin` branch for instructions.


## ⚠️ Disclaimer

These scripts are intended for **reference, learning, and practice purposes only**. Please **review and modify them** according to your organization's infrastructure, security policies, and environment.

- Tested using **Ubuntu instances on AWS EC2**.
- Minimum recommended instance type: **t2.medium** for both master and worker nodes.

## 🔁 Important Note on `sudo reboot`

This guide includes a `sudo reboot` command to apply updates and hostname changes. Please be aware of the following:

- On **cloud platforms like AWS**, `sudo reboot` will **not delete** your server, but it will **temporarily disconnect your SSH session**. You will need to **SSH again after the instance restarts**.
- In **production environments**, rebooting a node may impact running workloads or critical services.
  - Ensure reboots are done during maintenance windows or in coordination with your DevOps team.
  - In real production clusters, node reboots are typically handled via automated orchestration tools with proper draining and safety mechanisms.

⚠️ Only run `sudo reboot` if you fully understand the impact in your specific environment.
