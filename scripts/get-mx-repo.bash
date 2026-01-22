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
    rm -rf mx

    # mx is needed for building graal repo
    git clone --depth=1 --branch 7.68.11 https://github.com/graalvm/mx
    cd mx
    git config user.name gautham
    git config user.email gautham@elide.dev

    cd "$BASELOC"
}

main
