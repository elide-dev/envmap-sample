
export SHELL:=bash
export BASELOC:=$(shell pwd)
SCRIPTS:=$(wildcard scripts/*.bash)
SCRIPTS_BASE=$(basename $(notdir $(SCRIPTS)))

all:
	@echo "make all does nothing."
	@echo "run make <TARGET>, where TARGET is one of:"
	@echo "    "$(SCRIPTS_BASE)
	@echo "or run 'make clean' to remove built directories"

clean:
	rm -rf build
	rm -rf testing
	rm -f results/*.complete

# loop to write foo: results/foo.complete
define RENAMERULE =
$(1): results/$(1).complete
endef
$(foreach script,$(SCRIPTS_BASE),$(eval $(call RENAMERULE,$(script))))

# results/foo.complete: scripts/foo.bash
results/%.complete: scripts/%.bash
	source $(BASELOC)/config/required-vars && bash $(BASELOC)/$<
	touch $@

# specific dependencies
results/get-mx-labs-jdk.complete: results/get-mx-repo.complete

results/build-cosmocc.complete: results/patch-cosmo-repo.complete

results/build-deps-labs.complete: results/build-cosmocc.complete

results/build-graal-helpers.complete: \
	results/build-cosmocc.complete \
	results/get-mx-labs-jdk.complete \
	results/patch-graalvm-repo.complete

results/build-labs-jdk.complete: \
	results/patch-labs-jdk.complete \
	results/get-boot-jdk.complete \
	results/build-deps-labs.complete

results/collect-cosmocc.complete: results/build-cosmocc.complete

results/collect-graal-helpers.complete: results/build-graal-helpers.complete

results/collect-labs-jdk.complete: results/build-labs-jdk.complete

results/build-native-image.complete: \
	results/patch-graalvm-repo.complete \
	results/get-mx-labs-jdk.complete

results/build-envmap-example.complete: \
	results/get-envmap-example.complete \
	results/build-native-image.complete

results/build-google-java-format.complete: \
	results/get-google-java-format.complete \
	results/build-native-image.complete
