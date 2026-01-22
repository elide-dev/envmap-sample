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
    cd "$BASELOC/testing/cosmopolitan"
    ./tool/cosmocc/package.sh cosmocc
    ./cosmocc/bin/x86_64-unknown-cosmo-cc -v
    cd "$BASELOC"
}

main
