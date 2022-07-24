BUILDROOT_DIR = ./buildroot
BUILDROOT_VER = 2022.02.3

DEFCONFIG = rpi4_defconfig
SDCARD_IMG_PATH = $(BUILDROOT_DIR)/output/images/sdcard.img

WLOOP_OS_DIR = $(shell readlink -f ./wloop_os)
BR2_EXT_ = BR2_EXTERNAL\=$(WLOOP_OS_DIR)

all:
	cd $(BUILDROOT_DIR) && make

.PHONY: defconfig
defconfig:
	cd $(BUILDROOT_DIR) && make $(BR2_EXT_) $(DEFCONFIG)

.PHONY: savedefconfig
savedefconfig:
	cd $(BUILDROOT_DIR) && make $(BR2_EXT_) savedefconfig

.PHONY: menuconfig
menuconfig:
	cd $(BUILDROOT_DIR) && make $(BR2_EXT_) menuconfig

.PHONY: buildroot
buildroot:
	# install buildroot
	wget https://buildroot.org/downloads/buildroot-$(BUILDROOT_VER).tar.gz
	tar -xvzf buildroot-$(BUILDROOT_VER).tar.gz
	rm buildroot-$(BUILDROOT_VER).tar.gz
	mv buildroot-$(BUILDROOT_VER) $(BUILDROOT_DIR)

.PHONY: sdcard
sdcard:
	sudo fdisk -l | sed -e '/Disk \/dev\/loop/,+5d'
	echo -n "Enter SD card path (e.g. /dev/sdc): " && \
		read SDCARD && \
		sudo umount $$SDCARD* ; \
		sudo dd bs=1M if=$(SDCARD_IMG_PATH) of=$$SDCARD status=progress


.PHONY: dependencies
dependencies:
	sudo apt install -y \
		sed \
		make \
		binutils \
		gcc \
		g++ \
		bash \
		patch \
		gzip \
		bzip2 \
		perl \
		tar \
		cpio \
		unzip \
		rsync \
		wget \
		libncurses-dev \
		coreutils

.PHONY: clean
clean:
	rm -rf $(BUILDROOT_DIR)

