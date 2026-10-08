#!/usr/bin/env bash
set -euo pipefail

REPO_SSH_URL="git@github.com:higorrg/my-ubuntu-init-tools.git"
REPO_DIR="$HOME/workspace/my-ubuntu-init-tools"

sudo apt update && sudo apt install ansible -y
ansible-galaxy collection install community.general
ansible-playbook -i inventory.ini playbook.yml "$@"

# Login interativo: abre o navegador e oferece enviar ~/.ssh/id_ed25519.pub para o GitHub
if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  gh auth login --hostname github.com --git-protocol ssh --web
fi

if [ ! -d "$REPO_DIR/.git" ]; then
  git clone "$REPO_SSH_URL" "$REPO_DIR"
fi
