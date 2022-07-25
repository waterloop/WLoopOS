## WLoopOS

The best OS ever created!!!

In all seriousness, this repo contains a buildroot project to build a minimal Linux image
to be used for the RPi on the pod.

### Dependencies

The only real dependency here is buildroot (and all of buildroot's dependencies).
That being said, all dependencies can be installed via `make dependencies`.

### Building

For a one-shot, fully automated build, you can run `./build.sh`.

For a more manual approach:

```bash
make buildroot
make defconfig
make
```

**NOTE**:
* The defconfig for this project is configured to use 4 CPU cores
* This can be changed via the `BR2_JLEVEL` variable in the defconfig

### Flashing SD Card

Once the base image has been created (sdcard.img), you can write it to an SD card with:

```bash
make sdcard
```

There also exist many GUIs to do this as well (including the official Raspberry Pi imager).

### Developing for WLoopOS

The main thing you will probably be tweaking is the `rpi4_defconfig`, short for "default
configuration". Buildroot provides a "GUI" to edit defconfig files (accessible via `make
menuconfig`).

The process of editing the defconfig is as such:

```bash
make buildroot      # if you haven't done this yet...
make defconfig      # if you haven't done this yet...

make menuconfig
# make some changes in the menuconfig...

make savedefconfig  # save the changes back
```

