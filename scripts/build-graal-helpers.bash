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

    cd substratevm
    mx clean
    mx build \
        --projects com.oracle.svm.native.jvm.posix,com.oracle.svm.native.libchelper,com.oracle.svm.native.libcontainer \
        --alt-cc $COSMOCC/bin/$ARCH-unknown-cosmo-cc \
        --alt-cxx $COSMOCC/bin/$ARCH-unknown-cosmo-c++ \
        --alt-ar $COSMOCC/bin/$ARCH-linux-cosmo-ar

    RESULT_DIR="$BASELOC/build/graal-$ARCH-helpers"
    mkdir -p "$RESULT_DIR"
    cp $(find mxbuild -name '*.a' | grep glibc | xargs ls -t | head -n 3) "$RESULT_DIR"

    cd "$BASELOC"
}

main
