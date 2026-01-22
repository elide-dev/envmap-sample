#!/bin/bash
set -eux

check_baseloc () {
    if [ -n "$BASELOC" ]; then
        echo "BASELOC is given as $BASELOC"
    else
        echo "BASELOC is not set!"
        exit 1
    fi
}

check_vars () {
    check_baseloc
}

main () {
    check_vars
    #
    mkdir -p "$BASELOC/testing"
    cd "$BASELOC/testing"

    if [ ! -d "cosmopolitan" ]; then
        rm -rf cosmopolitan
        git clone --depth=1 --branch=header-stubs https://github.com/ahgamut/cosmopolitan
    fi
    cd cosmopolitan
    ls /proc/sys/fs/binfmt_misc/

    cd "$BASELOC/testing"
    rm -rf superconfigure
    git clone https://github.com/ahgamut/superconfigure
    cd superconfigure
    git checkout -b graal-setup e942f14a4cee4a678ac02a4a9df57bddba5e0c3d

    cd "$BASELOC"
}

main
