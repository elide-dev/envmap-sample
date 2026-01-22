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

check_boot_jdk () {
    if [ -n "$BOOT_JDK_PATH" ]; then
        echo "BOOT_JDK_PATH is given as $BOOT_JDK_PATH"
    else
        echo "BOOT_JDK_PATH is not set!"
        exit 1
    fi
}

check_vars () {
    check_baseloc
    check_arch
    check_boot_jdk
}

main () {
    check_vars
    OLD_BASELOC="$BASELOC"
    #
    cd "$BASELOC/testing/superconfigure"
    source config/vars-$ARCH

    cd "$OLD_BASELOC/testing/labs-openjdk"
    CXXFLAGS="--std=c++17 -Wno-template-id-cdtor -Wno-calloc-transposed-args -D_LARGEFILE64_SOURCE"
    CFLAGS="-Wno-calloc-transposed-args -D_LARGEFILE64_SOURCE"
    rm -rf ./build

    bash ./configure  \
        --openjdk-target="$ARCH-linux-gnu" \
        --with-boot-jdk="$BOOT_JDK_PATH" \
        --with-x=no \
        --with-fontconfig=no \
        --with-alsa=no \
        --with-cups=no \
        --with-jvm-variants=server \
        --prefix="$OLD_BASELOC/build" \
        --with-extra-cflags="$CFLAGS" \
        --with-extra-cxxflags="$CXXFLAGS" \
        --with-memory-size=2048 \
        --with-native-debug-symbols=none \
        --disable-warnings-as-errors \
        --disable-precompiled-headers \
        --enable-dtrace=no \
        --with-debug-level=release \
        AR="$AR" \
        STRIP="$STRIP" \
        OBJCOPY="$OBJCOPY"

    make static-libs-image

    # this is like a 'make install' step
    SOURCE_LIBDIR="$(realpath ./build/linux-$ARCH-server-release/images/static-libs/lib)"
    TARGET_LIBDIR="$OLD_BASELOC/build/labs-$ARCH-cosmo-libs"
    mkdir -p "$TARGET_LIBDIR"

    cp "$SOURCE_LIBDIR"/*.* "$TARGET_LIBDIR"
    cp -r "$SOURCE_LIBDIR"/server "$TARGET_LIBDIR"

    cd "$OLD_BASELOC"
}

main
