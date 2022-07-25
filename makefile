THIS_DIR := $(shell readlink -f .)

BUILD_DIR = ./build
SDCARD_IMG_PATH = $(BUILD_DIR)/sdcard.img

KERNEL_DIR = ./linux
KERNEL_TARBALL_DIR = $(BUILD_DIR)/linux.tar.gz
RPI_KERNEL_COMMIT_HASH = 0b54dbda3cca2beb51e236a25738784e90853b64

BUILDROOT_DIR = ./buildroot
BUILDROOT_VER = 2022.02.3

DEFCONFIG = rpi4_defconfig
WLOOP_OS_DIR = $(THIS_DIR)/wloop_os
BOARD_DIR = $(WLOOP_OS_DIR)/board/rpi4

BR2_EXT_ = BR2_EXTERNAL\=$(WLOOP_OS_DIR)
TOPDIR_ = TOPDIR\=$(THIS_DIR)

# KERNAL_TARBALL_ = KERNAL_TARBALL\=$(KERNEL_TARBALL_DIR)

all: $(BUILD_DIR)
	cd $(BUILDROOT_DIR) && make
	cp $(BUILDROOT_DIR)/output/images/sdcard.img $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $@

.PHONY: defconfig
defconfig:
	cd $(BUILDROOT_DIR) && make $(BR2_EXT_) $(TOPDIR_) $(DEFCONFIG)

.PHONY: savedefconfig
savedefconfig:
	cd $(BUILDROOT_DIR) && make $(BR2_EXT_) $(TOPDIR_) savedefconfig

.PHONY: menuconfig
menuconfig:
	cd $(BUILDROOT_DIR) && make $(BR2_EXT_) $(TOPDIR_) menuconfig

.PHONY: buildroot
buildroot:
	# install buildroot
	wget https://buildroot.org/downloads/buildroot-$(BUILDROOT_VER).tar.gz
	tar -xvzf buildroot-$(BUILDROOT_VER).tar.gz
	rm buildroot-$(BUILDROOT_VER).tar.gz
	mv buildroot-$(BUILDROOT_VER) $(BUILDROOT_DIR)

.PHONY: kernel
kernel: $(BUILD_DIR)
	wget -O - https://github.com/raspberrypi/linux/tarball/$(RPI_KERNEL_COMMIT_HASH) | tar xz
	# mv raspberrypi-linux-* $(KERNEL_DIR)

	@echo "compressing into tarball..."
	tar -cvzf $(KERNEL_TARBALL_DIR) raspberrypi-linux-0b54dbd
	# tar -cvzf $(KERNEL_TARBALL_DIR) $(KERNEL_DIR)

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
	rm -rf $(KERNEL_DIR)
	rm -rf $(BUILD_DIR)

