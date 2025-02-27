#!/bin/bash
sudo apt update -y
sudo apt install -y ansible git

# Run Ansible Pull to apply configurations from our repo
ansible-pull -U https://github.com/Samuel-Oyedeji/DevOps-Stage-4-Infrastructure.git -i localhost, -d /home/ubuntu/ansible

# go to the playbook directory
cd ansible/ansible

# start the playbook
ansible-playbook playbook.yml