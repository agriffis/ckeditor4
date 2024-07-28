# Use JAVA15_HOME if set.
export JAVA_HOME := $(or $(JAVA15_HOME), $(JAVA_HOME))
export PATH := $(JAVA_HOME)/bin:$(PATH)

# CUBCHICKEN must be set for install.
TARGET = $(CUBCHICKEN)/src/main/webapp/aa_shared/vendor

CONFIG = dev/builder/build-config.js
TARBALL = dev/builder/release/ckeditor_4.22.0_dev.tar.gz

.PHONY: build
build:
	./dev/builder/build.sh

$(TARBALL): $(CONFIG)
	$(MAKE) build

.PHONY: install
install: $(TARBALL)
	@if [ ! -d "$(TARGET)" ]; then \
		if [ -z "$(CUBCHICKEN)" ]; then \
			echo "Missing variable: CUBCHICKEN" >&2; \
		else \
			echo "Missing directory: $(TARGET)" >&2 ; \
		fi; \
		exit 1; \
	fi
	rm -rf "$(TARGET)/ckeditor"
	tar xzf "$(TARBALL)" -C "$(TARGET)"
	find "$(TARGET)/ckeditor" -type f -print0 | xargs -0r dos2unix
