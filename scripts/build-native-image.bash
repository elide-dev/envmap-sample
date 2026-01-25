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

check_jdk_labs () {
    if [ -n "$MX_JDK_LABS" ]; then
        echo "MX_JDK_LABS is given as $MX_JDK_LABS"
    else
        echo "MX_JDK_LABS is not set!"
        exit 1
    fi
}

check_vars () {
    check_baseloc
    check_arch
    check_jdk_labs
}

main () {
    check_vars
    #
    cd "$BASELOC/testing/graal"
    export PATH="$BASELOC/testing/mx:$PATH"
    export JAVA_HOME="$MX_JDK_LABS"

    cd vm
    mx clean
    mx -c 1 --dy /substratevm --native-images=native-image build
    mx -c 1 --dy /substratevm --native-images=native-image graalvm-home
    mx --dy /substratevm --native-images=native-image graalvm-show 2>&1 | head -50
    ls "$(mx -c 1 --dy /substratevm --native-images=native-image graalvm-home)"

    cd "$BASELOC"
}

main
