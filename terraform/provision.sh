#!/bin/bash
# wait time 
sleep 20

sudo apt update -y
sudo apt install -y ansible git

# wait time 
sleep 20

# Run Ansible Pull to apply configurations from our repo
ansible-pull -U https://github.com/Samuel-Oyedeji/DevOps-Stage-4-Infrastructure.git -i localhost, -d /home/ubuntu/ansible

# wait time 
sleep 10

# go to the playbook directory
cd /home/ubuntu/ansible/ansible

# start the playbook
ansible-playbook playbook.yml