#!/bin/bash
set -e

(
	cd toolchain
	tar xfv gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux.tar.xz
)
export CROSS_CC=`pwd`/toolchain/gcc-linaro-arm-linux-gnueabihf-4.9-2014.09_linux/bin/arm-linux-gnueabihf-

(
	cd u-boot
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} distclean
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} mx53loco_defconfig
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} -j5
)


(
	cd linux
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} distclean
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} imx_v6_v7_defconfig
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} -j5
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} zImage -j5
	make ARCH=arm CROSS_COMPILE=${CROSS_CC} imx53-qsb.dtb

	mkdir -p ../output/modules
	make ARCH=arm INSTALL_MOD_PATH=../output/modules modules_install
)

exit 0
