# Create directories that nerves-config expects before it tries to install
define NERVES_CONFIG_CREATE_DIRS
	mkdir -p $(HOST_DIR)/opt/ext-toolchain/bin/
	mkdir -p $(HOST_DIR)/opt/ext-toolchain/gcc/aarch64-buildroot-linux-gnu/bin/
	# Create the .br_real file that ccache expects
	cp -f $(BR2_EXTERNAL_NERVES_PATH)/package/nerves-config/echo-gcc-args $(HOST_DIR)/bin/echo-gcc-args.br_real
endef

NERVES_CONFIG_PRE_INSTALL_TARGET_HOOKS += NERVES_CONFIG_CREATE_DIRS

# Include custom packages
include $(sort $(wildcard $(NERVES_DEFCONFIG_DIR)/package/*/*.mk))