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
    RESULT_DIR="$BASELOC/build"
    mkdir -p "$RESULT_DIR"
    cd "$BASELOC/testing/cosmopolitan"
    zip -r cosmocc.zip cosmocc
    mv cosmocc.zip "$RESULT_DIR"
    cd "$BASELOC"
}

main
