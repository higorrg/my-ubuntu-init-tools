#!/usr/bin/env bash
set -euo pipefail

sudo apt update && sudo apt install ansible -y
ansible-galaxy collection install community.general
ansible-playbook -i inventory.ini playbook.yml
