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
    NATIMG_PATH="$BASELOC/testing/graal/vm/latest_graalvm_home"
    COSMOCC_BIN="$BASELOC/testing/cosmopolitan/cosmocc/bin"
    export PATH="$NATIMG_PATH/bin:$COSMOCC_BIN:$BASELOC/testing/mx:$PATH"
    LABS_LIBDIR="$BASELOC/build/labs-$ARCH-cosmo-libs"

    if [ x"$ARCH" = x"x86_64" ]; then
        SUBARCH="amd64"
        PFE_OPT="18,16"
    elif [ x"$ARCH" = x"aarch64" ]; then
        SUBARCH="aarch64"
        PFE_OPT="7,6"
    fi

    NATIMG_COSMO="$NATIMG_PATH/lib/svm/clibraries/linux-$SUBARCH/cosmo"
    mkdir -p "$NATIMG_COSMO"
    cp ./build/graal-$ARCH-helpers/*.a "$NATIMG_COSMO"

    cd "$BASELOC/testing/google-java-format"
    native-image \
        -jar google-java-format.jar \
        -Os \
        --libc=cosmo \
        -H:-CheckToolchain \
        -march=compatibility \
        -H:+UnlockExperimentalVMOptions\
        -H:IncludeResourceBundles=com.sun.tools.javac.resources.compiler\
        -H:IncludeResourceBundles=com.sun.tools.javac.resources.javac \
        --no-fallback --initialize-at-build-time=com.sun.tools.javac.file.Locations \
        -H:-UseContainerSupport \
        -J--add-exports=jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
        -J--add-exports=jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED \
        -J--add-exports=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
        -J--add-exports=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
        -J--add-exports=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
        -J--add-exports=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED  \
        --static \
        -H:CCompilerPath="$COSMOCC_BIN/$ARCH-unknown-cosmo-cc" \
        -H:CLibraryPath="$LABS_LIBDIR" \
        -H:PatchableFunctionEntry="$PFE_OPT"\
        -R:StackSize=1048576 \
        -o "google-java-format.$ARCH"

    cd "$BASELOC/build"
    cp "$BASELOC/testing/google-java-format/google-java-format.$ARCH" .

    cd "$BASELOC"
}

main
