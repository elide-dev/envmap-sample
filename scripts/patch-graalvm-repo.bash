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
    rm -rf graal

    cd "$BASELOC/testing"
    git clone --depth 1 --branch cosmo https://github.com/elide-dev/graal
    cd graal

    cd "$BASELOC"
}

main
