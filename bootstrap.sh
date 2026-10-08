#!/usr/bin/env bash
# Uso em uma instalação nova (não requer git nem chave SSH):
#   bash -c "$(wget -qO- https://raw.githubusercontent.com/higorrg/my-ubuntu-init-tools/main/bootstrap.sh)"
set -euo pipefail

TARBALL_URL="https://codeload.github.com/higorrg/my-ubuntu-init-tools/tar.gz/refs/heads/main"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

if command -v wget >/dev/null; then
  wget -qO- "$TARBALL_URL"
else
  curl -fsSL "$TARBALL_URL"
fi | tar -xz -C "$WORK_DIR" --strip-components=1

cd "$WORK_DIR"
bash run.sh "$@"
