#!/bin/sh

set -eux

install_path=$HOME/.local

repo_root=$(git -C $(dirname $0) rev-parse --show-toplevel)
cd $repo_root

echo "Pulling submodules..."
core_submodules_path=$repo_root/submodules/core
git submodule update --init --recursive $core_submodules_path

echo "Compiling and installing git..."
cd $core_submodules_path/git
sudo apt install --yes --no-install-recommends asciidoc autoconf curl expat openssl perl python xmlto
make configure
./configure --prefix=$install_path
# Do not localize Git and do not install gitk/git-gui
make install install-man NO_GETTEXT=YesPlease NO_TCLTK=YesPlease

