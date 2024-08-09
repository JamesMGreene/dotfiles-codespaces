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

# Install diff-so-fancy for richer git diffs
git clone https://github.com/so-fancy/diff-so-fancy ~/diff-so-fancy
chmod +x ~/diff-so-fancy/diff-so-fancy
sudo ln -s ~/diff-so-fancy/diff-so-fancy /usr/local/bin/diff-so-fancy

# Copy individual files, because anything else is too finicky to work
# Also, the presence of this install script prevents other dotfiles files from being copied over into the HOME directory
# See: https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles
DOTFILES=/workspaces/.codespaces/.persistedshare/dotfiles
cp $DOTFILES/.gitignore.global ~/.gitignore.global
cp $DOTFILES/.gitconfig.local ~/.gitconfig.local
cp $DOTFILES/.gitconfig ~/.gitconfig
cp $DOTFILES/sync-history.sh ~/sync-history.sh
cp $DOTFILES/.bashrc.local ~/.bashrc.local

# Install Homebrew on Linu
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to the path
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "# Add Homebrew to the path" >> ~/.bashrc.local
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc.local

echo 'source "$HOME/.bashrc.local"' >> ~/.bashrc

# Ensure the new bash config gets sourced
source ~/.bashrc
