#!/usr/bin/env bash

# Get the Ubuntu version
UBUNTU_VERSION=$(grep -oP 'VERSION_ID="\K[^"]+' /etc/os-release)

# Define the minimum required version
REQUIRED_VERSION="24.04"

# Check if the current version meets the requirement
if (( $(echo "$UBUNTU_VERSION < $REQUIRED_VERSION" | bc -l) )); then
    echo "This script requires Ubuntu $REQUIRED_VERSION."
    echo "Your current Ubuntu version is $UBUNTU_VERSION."
  	echo "This script is target to Gnome version 46."
  	echo "Update gnome extensions versions according to Gnome Version before proceed."
    exit 1 # Exit the script
fi

# If the version is sufficient, continue with the rest of the script
echo "Ubuntu version $UBUNTU_VERSION is compatible. Proceeding with script execution."
# Your script's main logic goes here


echo "############################################################"
echo "## INSTALLING BASIC TOOLS"
echo "############################################################"
echo .
sudo apt update && sudo apt install \
    git \
    vim \
    curl \
    fonts-powerline \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    terminator \
    tree \
    httpie -y

echo "############################################################"
echo "## INSTALLING ZSH"
echo "############################################################"
$(sudo apt install zsh -y && exit)
echo "############################################################"
echo "## INSTALLING OH-MY-ZSH"
echo "############################################################"
CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "############################################################"
echo "#CUSTOMIZING SHELL"
echo "############################################################"
sed -i 's/robbyrussell/fino-time/g' ~/.zshrc
echo "alias l='ls -lh'" >> ~/.zshrc
echo "alias ll='ls -lha'" >> ~/.zshrc
sed -i "s/'ls -alF'/'ls -lha'/g" ~/.bashrc
sed -i "s/'ls -CF'/'ls -lh'/g" ~/.bashrc
echo 'prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m %D{%f/%m/%y} %D{%K:%M:%S}\n"
  fi
}

# Custom completion for java command to include .java files
_java_completion() {
  local state line
  _arguments \
    '*:file:_files -g "*.java" -g "*.class"'
}
compdef _java_completion java' >> ~/.zshrc

echo "############################################################"
echo "## INSTALLING GOOGLE CHROME"
echo "############################################################"
echo .
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo apt install chrome-gnome-shell 
echo "############################################################"
echo "## INSTALLING GNOME EXTENSIONS"
echo "############################################################"
echo .
sudo apt install gnome-shell-extensions
echo "############################################################"
echo "## INSTALLING Transparent Top Bar EXTENSION"
echo "############################################################"
echo .
wget https://extensions.gnome.org/extension-data/transparent-top-barftpix.com.v24.shell-extension.zip
gnome-extensions install ./transparent-top-barftpix.com.v24.shell-extension.zip
gnome-extensions enable transparent-top-bar@ftpix.com
echo "############################################################"
echo "## INSTALLING Top Panel Workspace Scroll EXTENSION"
echo "############################################################"
echo .
wget https://extensions.gnome.org/extension-data/scroll-workspacesgfxmonk.net.v38.shell-extension.zip
gnome-extensions install ./scroll-workspacesgfxmonk.net.v38.shell-extension.zip
gnome-extensions enable scroll-workspaces@gfxmonk.net
echo "############################################################"
echo "## INSTALLING Clipboard Indicator Scroll EXTENSION"
echo "############################################################"
echo .
wget https://extensions.gnome.org/extension-data/clipboard-indicatortudmotu.com.v68.shell-extension.zip
gnome-extensions install ./clipboard-indicatortudmotu.com.v68.shell-extension.zip
gnome-extensions enable clipboard-indicator@tudmotu.com
echo "############################################################"
echo "## INSTALLING DBEAVER"
echo "############################################################"
echo .
sudo snap install dbeaver-ce
echo "############################################################"
echo "## PREPARING PODMAN INSTALL"
echo "############################################################"
echo .
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
echo "############################################################"
echo "## INSTALLING PODMAN"
echo "############################################################"
sudo apt-get install podman podman-compose -y
echo "Habilitando TestContainers com Podman"
systemctl --user enable --now podman.socket
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock
export TESTCONTAINERS_RYUK_DISABLED=true
mkdir ~/workspace
mkdir ~/opt
echo "############################################################"
echo "## INSTALLING SDK MAN"
echo "############################################################"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo "############################################################"
echo "## INSTALLING SDKs"
echo "############################################################"
sdk install java 21.0.8-sem && \
sdk install maven && \
sdk install quarkus && \
sdk install jbang
echo "############################################################"
echo "## INSTALLING NPM/NVM (Somente aceita no bash)"
echo "############################################################"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
echo "## Configurando zshrc para NVM pq ele não aceita ser instalado direto no zsh"
echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' > ~/.zshrc
echo "## Habilitando NVM no momento"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 22
echo "Verify the Node.js version: Should print v22.17.1"
node -v
echo "Verify the NVM version: Should print v22.17.1"
nvm current
echo "Verify npm version: Should print 10.9.2"
npm -v
echo "############################################################"
echo "## INSTALLING Visual Studio Code"
echo "############################################################"
flatpak install -y flathub com.visualstudio.code
echo "############################################################"
echo "## INSTALLING IntelliJ-IDEA-Community"
echo "############################################################"
flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community
