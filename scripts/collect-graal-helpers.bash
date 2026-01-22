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

check_arch () {
    if [ -n "$ARCH" ]; then
        echo "ARCH is given as $ARCH"
    else
        echo "ARCH is not set!"
        exit 1
    fi
}

check_vars () {
    check_baseloc
    check_arch
}

main () {
    check_vars
    #
    RESULT_DIR="$BASELOC/build/graal-$ARCH-helpers"

    cd "$BASELOC/build"
    zip -r "graal-$ARCH-helpers.zip" graal-$ARCH-helpers

    cd "$BASELOC"
}

main
