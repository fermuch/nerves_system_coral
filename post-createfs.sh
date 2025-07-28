#!/bin/sh

set -ex

cp ${BINARIES_DIR}/uboot-env.bin ${BOOTFATDIR}/uboot-env.bin


# # Run the common post-image processing for nerves
# $BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh \
#   $TARGET_DIR \
#   $NERVES_DEFCONFIG_DIR/fwup.conf
