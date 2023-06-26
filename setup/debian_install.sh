#!/bin/bash

# Installing programs with apt-get
# We use apt-get for programs that are not trivial to install via a script

# Install Z shell
sudo apt-get --yes install zsh=5.8-3ubuntu1.1
# Make it default shell
# Ref: https://askubuntu.com/a/131838
sudo chsh -s $(which zsh)

# Install neovim
# We want v0.8 to use nvim-lspconfig
# Unfortunately, base apt has up to v0.4 and neovim-ppa/stable has up to 0.7
neovim_url="https://github.com/neovim/neovim/releases/download/v0.8.3/nvim-linux64.deb"
neovim_deb_path="/tmp/nvim-linux64.deb"
curl -sSL $neovim_url > $neovim_deb_path  # Overwrite file if script is run multiple times
sudo apt install $neovim_deb_path

# Install Pyright (Python language server)
# We use sudo as we want to install it system-wide, not really recommended as permission issues may
# arise, but for now it works without problems
sudo apt-get --yes install python3-pip
sudo pip3 install pyright

# Installing programs in the submodules directory
# We use submodules for programs that offer a simple installation script

# Note: For this to work you must have cloned the github repo to your home folder as ~/dotfiles
repo_dir=dotfiles
submodules_dir=submodules
submodules_path=~/$repo_dir/$submodules_dir

# Pull submodules
git submodule update --init --recursive $submodules_path

# Install fuzzy finder
# This appends stuff to .zshrc, we redirect the new lines in an ad-hoc file for tidyness
mv ~/.zshrc ~/.zshrc.backup
> ~/.zshrc.fzf
ln -s ~/.zshrc.fzf ~/.zshrc
yes | $submodules_path/fzf/install --no-bash
mv ~/.zshrc.backup ~/.zshrc

# Install nvim plugin manager
packer_installation_path=~/.config/nvim/pack/packer/start
mkdir -p $packer_installation_path
rm -rf $packer_installation_path/packer.nvim
cp -r $submodules_path/packer.nvim $packer_installation_path
# Install the plugins
# We use the last command to wait for the other two to finish
# Ref: https://github.com/wbthomason/packer.nvim/pull/259
nvim --headless -c "PackerCompile" -c "PackerInstall" -c "autocmd User PackerComplete qa"

