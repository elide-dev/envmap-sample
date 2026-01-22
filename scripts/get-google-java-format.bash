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
    mkdir -p testing/google-java-format
    cd testing/google-java-format
    wget -qO google-java-format.jar 'https://github.com/google/google-java-format/releases/download/v1.33.0/google-java-format-1.33.0-all-deps.jar'
}

main
