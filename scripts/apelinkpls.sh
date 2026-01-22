#!/bin/bash
set -eux

main () {
    BASELOC="$(pwd)"
    COSMOCC_PATH="$BASELOC/testing/cosmopolitan/cosmocc/bin"
    BASEFILE="${1:-envmap}"

    APELINK="$COSMOCC_PATH/apelink"
    FIXUPOBJ="$COSMOCC_PATH/fixupobj"

    "$FIXUPOBJ" "$BASEFILE.x86_64"
    "$FIXUPOBJ" "$BASEFILE.aarch64"

    "$APELINK" \
        -l "$COSMOCC_PATH/ape-x86_64.elf" \
        -l "$COSMOCC_PATH/ape-aarch64.elf" \
        -M "$COSMOCC_PATH/ape-m1.c" \
        -o "$BASEFILE.com" \
        "$BASEFILE.x86_64"\
        "$BASEFILE.aarch64"
}

main "$1"
