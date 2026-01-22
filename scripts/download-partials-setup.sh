#!/usr/bin/env bash

check_arch () {
    if [ -n "$ARCH" ]; then
        echo "ARCH is given as $ARCH"
    else
        echo "ARCH is not set!"
        exit 1
    fi
}

check_arch

mkdir -p testing/cosmopolitan
cd testing/cosmopolitan
unzip -qo ../../cosmocc.zip

cd ../../
mkdir -p build
cd build
unzip -qo ../labs-$ARCH-cosmo-libs.zip
unzip -qo ../graal-$ARCH-helpers.zip

cd ..
mkdir -p results
# because we downloaded the libs, mark these steps as complete
touch results/get-boot-jdk.complete
touch results/patch-cosmo-repo.complete
touch results/build-deps-labs.complete
touch results/build-cosmocc.complete
touch results/patch-labs-jdk.complete
touch results/build-labs-jdk.complete
touch results/build-graal-helpers.complete
