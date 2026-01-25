#!/usr/bin/env bash

# ssl certs
sudo apt-get install -y ca-certificates libssl-dev\
    qemu-user-static qemu-user binfmt-support \
    texinfo groff libtool tree\
    cmake ninja-build bison flex zip unzip lzip\
    pkg-config build-essential autoconf re2c

mkdir -p testing
cd testing
# cosmo
git clone https://github.com/ahgamut/cosmopolitan --depth=1 --branch=header-stubs
cd cosmopolitan
sudo bash ape/apeinstall.sh
sudo rm -rf ./o
ls /proc/sys/fs/binfmt_misc/
