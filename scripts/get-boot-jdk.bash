#!/bin/bash

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
    # SDKMAN_DIR="${SDKMAN_DIR:-$BASELOC/testing/sdkman}"

    cd "$BASELOC/testing"
    rm -rf "sdkman"
    export SDKMAN_DIR="$BASELOC/testing/sdkman"
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
    ls sdkman/bin

    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk install java 25.0.1-open
    ls "$BASELOC/testing/sdkman/candidates/java"

    cd "$BASELOC"
}

main
