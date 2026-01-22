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
    OLD_BASELOC="$BASELOC"
    #
    cd "$BASELOC/testing/superconfigure"
    ln -sf ../cosmopolitan .

    # builds cosmocc if it hasn't been built already
    ./.github/scripts/cosmo

    # dependencies for labs jdk: libpng, libjpeg, freetype, libz
    LOG=stdout make \
        o/cosmo-repo/compress/built.fat \
        o/lib/libpng/built.fat \
        o/lib/libjpeg/built.fat \
        o/lib/freetype/built.fat

    cd "$OLD_BASELOC"
}

main
