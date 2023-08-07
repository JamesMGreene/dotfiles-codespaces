#!/usr/bin/env bash

set -e
set -o pipefail

# Install updates to apt-get
sudo apt-get update -y

# Install cURL
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)

# Prepare to install the GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update -y

# Install the GitHub CLI
sudo apt install gh -y

# Install hub
sudo apt-get install hub -y

# Copy individual files, because anything else is too finicky to work
# Also, the presence of this install script prevents other dotfiles files from being copied over into the HOME directory
# See: https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles
DOTFILES=/workspaces/.codespaces/.persistedshare/dotfiles
cp $DOTFILES/.bashrc ~/.bashrc
cp $DOTFILES/sync-history.sh ~/sync-history.sh
cp $DOTFILES/.gitconfig ~/.gitconfig
cp $DOTFILES/.gitconfig.local ~/.gitconfig.local
cp $DOTFILES/.gitconfig.global ~/.gitconfig.global
