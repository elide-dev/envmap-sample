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
    SOURCE_LIBDIR="$BASELOC/testing/labs-openjdk/build/linux-$ARCH-server-release/images/static-libs/lib"
    SUPERCONF_LIBDIR="$BASELOC/testing/superconfigure/cosmos/$ARCH/lib"
    TARGET_LIBDIR="$BASELOC/build/labs-$ARCH-cosmo-libs"
    #

    mkdir -p "$TARGET_LIBDIR"
    # cp "$SOURCE_LIBDIR"/*.* "$TARGET_LIBDIR"
    # cp -r "$SOURCE_LIBDIR"/server "$TARGET_LIBDIR"

    # building with native-image definitely needs libz
    # does it need other static libraries, like libpng?
    cp "$SUPERCONF_LIBDIR"/libz.a "$TARGET_LIBDIR"

    cd "$BASELOC/build"
    zip -r "labs-$ARCH-cosmo-libs.zip" labs-$ARCH-cosmo-libs

    cd "$BASELOC"
}

main
