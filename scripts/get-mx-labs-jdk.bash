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
    mkdir -p "$BASELOC/testing"
    export PATH="$BASELOC/testing/mx:$PATH"

    if [ x"$ARCH" = x"x86_64" ]; then
        LABS_LINK="https://github.com/graalvm/labs-openjdk/releases/download/25.0.2%2B10-jvmci-b01/labsjdk-ce-25.0.2+10-jvmci-b01-linux-amd64.tar.gz"
    elif [ x"$ARCH" = x"aarch64" ]; then
        LABS_LINK="https://github.com/graalvm/labs-openjdk/releases/download/25.0.2%2B10-jvmci-b01/labsjdk-ce-25.0.2+10-jvmci-b01-linux-aarch64.tar.gz"
    else
        echo "ARCH is not set!"
        exit 1
    fi

    cd "$BASELOC/testing"
    wget "$LABS_LINK" -qO boot-labs-jdk.tar.gz
    tar xzf boot-labs-jdk.tar.gz
    mv labsjdk-ce-25.0.2-jvmci-b01 boot-labs-jdk

    ls boot-labs-jdk -al
    # mx fetch-jdk \
    #    labsjdk-ce-25 \
    #    --to "$BASELOC/testing/" \
    #    --alias "boot-labs-jdk"

    cd "$BASELOC"
}

main
