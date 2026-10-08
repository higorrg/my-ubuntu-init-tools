# Ubuntu-Linux-Env-Init-Script
Script para inicialização de novas instalações do Ubuntu (e derivados da família Debian: Kubuntu, Pop!_OS, Zorin, Deepin…) com todas as ferramentas que costumo utilizar.

## Instalação nova

Pré-requisitos: usuário com `sudo` e acesso à internet. Não requer git nem chave SSH.

1. Abra um terminal e rode:

   ```bash
   bash -c "$(wget -qO- https://raw.githubusercontent.com/higorrg/my-ubuntu-init-tools/main/bootstrap.sh)"
   ```

   > Use exatamente essa forma (e não `wget ... | bash`): o login no GitHub precisa ler respostas do terminal.

2. Informe a senha do `sudo` quando solicitado. O script instala o Ansible e executa o playbook, que entre outras coisas:
   - gera a chave SSH `~/.ssh/id_ed25519` (sem senha; se já existir, é mantida);
   - registra a chave de host do GitHub em `~/.ssh/known_hosts`;
   - instala o GitHub CLI (`gh`).

3. Ao final do playbook, o `gh auth login` inicia o login no GitHub:
   - copie o código exibido no terminal e confirme no navegador que abrir;
   - quando perguntado, aceite enviar a chave pública `~/.ssh/id_ed25519.pub` para a sua conta e dê um título a ela (ex.: o nome da máquina).

4. O repositório é clonado via SSH em `~/workspace/my-ubuntu-init-tools`. A cópia temporária baixada pelo bootstrap é removida.

5. Faça logout/login (ou reinicie) para aplicar o shell padrão `zsh` e o grupo `docker`.

Opcional: proteja a chave SSH com uma senha usando `ssh-keygen -p -f ~/.ssh/id_ed25519`.

## Executar novamente

```bash
cd ~/workspace/my-ubuntu-init-tools
./run.sh                 # tudo
./run.sh --tags docker   # apenas uma role
```

As etapas de login no GitHub e clone são ignoradas quando já foram feitas.

## Distribuições suportadas

Qualquer distro da família Debian com `apt`. O repositório do Docker é escolhido automaticamente a partir de `/etc/os-release`:

| Distro | Repositório Docker |
|---|---|
| Ubuntu e derivados (Kubuntu, Pop!_OS, Zorin, Mint…) | `ubuntu` + `UBUNTU_CODENAME` |
| Debian | `debian` + `VERSION_CODENAME` |
| Derivados do Debian que informam `DEBIAN_CODENAME` (ex.: LMDE) | `debian` + `DEBIAN_CODENAME` |
| Demais derivados do Debian (ex.: Deepin) | `debian` + `bookworm` (padrão) |

Se a detecção não servir, force o repositório:

```bash
./run.sh --tags docker -e docker_repo_distro=debian -e docker_repo_codename=trixie
```

Observações:
- As extensões do GNOME só são instaladas no Ubuntu 24.04+ com GNOME 46.
- O Google Chrome é instalado pelo pacote `.deb` amd64.
