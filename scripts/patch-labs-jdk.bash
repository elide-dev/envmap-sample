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
    mkdir -p "$BASELOC/testing"
    cd "$BASELOC/testing"
    rm -rf labs-openjdk

    git clone --depth=1 --branch 'cosmo-25.0.2' https://github.com/elide-dev/labs-openjdk
    cd labs-openjdk

    cd "$BASELOC"
}

main
