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
    COSMOCC="$BASELOC/testing/cosmopolitan/cosmocc"
    export PATH="$COSMOCC/bin:$PATH"

    cd substratevm
    mx clean
    MULTITARGET=linux-$ARCH-cosmo mx build \
        --projects com.oracle.svm.native.jvm.posix,com.oracle.svm.native.libchelper,com.oracle.svm.native.libcontainer

    RESULT_DIR="$BASELOC/build/graal-$ARCH-helpers"
    mkdir -p "$RESULT_DIR"
    cp $(find mxbuild -name '*.a' | grep cosmo | xargs ls -t | head -n 3) "$RESULT_DIR"

    cd "$BASELOC"
}

main
