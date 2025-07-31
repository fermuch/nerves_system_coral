################################################################################
#
# imx-board-wlan
#
################################################################################

# IMX_BOARD_WLAN_VERSION = 276713bbe1ec417fabbe91baeedad75bcb3bee31
# IMX_BOARD_WLAN_SITE = https://coral.googlesource.com/imx-board-wlan-src
IMX_BOARD_WLAN_VERSION = 7dc91e5977f31d60741c55682564788c0f930163
IMX_BOARD_WLAN_SITE = https://github.com/nxp-imx/qcacld-2.0-imx.git
IMX_BOARD_WLAN_SITE_METHOD = git
IMX_BOARD_WLAN_LICENSE = GPL-2.0
IMX_BOARD_WLAN_LICENSE_FILES = LICENSE
IMX_BOARD_WLAN_DEPENDENCIES = linux

# This is a Qualcomm CLD WiFi driver
define IMX_BOARD_WLAN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR) M=$(@D) \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		WLAN_ROOT=$(@D) \
		MODNAME=wlan \
		modules
endef

define IMX_BOARD_WLAN_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(LINUX_DIR) M=$(@D) \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		WLAN_ROOT=$(@D) \
		MODNAME=wlan \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		modules_install
endef

$(eval $(generic-package))