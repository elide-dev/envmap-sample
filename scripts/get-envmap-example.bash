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
    cd "$BASELOC"
    mkdir -p testing/envmap
    cd testing/envmap
    cp "$BASELOC/patches/EnvMap.java" .
}

main
