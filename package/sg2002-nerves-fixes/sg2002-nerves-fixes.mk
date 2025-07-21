#############################################################
#
# sg2002-nerves-fixes
#
#############################################################
SG2002_NERVES_FIXES_SOURCE      =
SG2002_NERVES_FIXES_VERSION     = 0.2
SG2002_NERVES_FIXES_DEPENDENCIES =

# Real compiler that the wrapper should use
REAL_CC = $(HOST_DIR)/opt/ext-toolchain/gcc/riscv64-linux-musl-x86_64/bin/echo-gcc-args

define SG2002_NERVES_FIXES_INSTALL_TARGET_CMDS
    # Create the missing .br_real stub for the wrapper
    mkdir -p $(HOST_DIR)/bin
    ( echo '#!/bin/sh'; \
      echo 'exec $(REAL_CC) "$$@"' ) > $(HOST_DIR)/bin/echo-gcc-args.br_real
    chmod 755 $(HOST_DIR)/bin/echo-gcc-args.br_real

    # Copy the extra copies that sg2002-nerves-fixes wants
    mkdir -p $(HOST_DIR)/opt/ext-toolchain/bin
    mkdir -p $(HOST_DIR)/opt/ext-toolchain/gcc/riscv64-linux-musl-x86_64/bin
    cp -f $(BR2_EXTERNAL)/package/nerves-config/echo-gcc-args $(BINARIES_DIR)/buildroot-gcc-args
    cp -f $(BR2_EXTERNAL)/package/nerves-config/echo-gcc-args $(REAL_CC)
endef

$(eval $(generic-package))
