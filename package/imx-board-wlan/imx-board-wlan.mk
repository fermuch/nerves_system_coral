################################################################################
#
# imx-board-wlan
#
################################################################################

IMX_BOARD_WLAN_VERSION = 276713bbe1ec417fabbe91baeedad75bcb3bee31
IMX_BOARD_WLAN_SITE = https://coral.googlesource.com/imx-board-wlan-src
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
		CONFIG_QCA_CLD_WLAN=m \
		CONFIG_QCA_WIFI_ISOC=0 \
		CONFIG_QCA_WIFI_2_0=1 \
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