#!/bin/bash

CONF_PATH=$BR2_EXTERNAL_WLoopOS_PATH/board/rpi4

cat $CONF_PATH/config.txt > ./output/images/rpi-firmware/config.txt
cat $CONF_PATH/cmdline.txt > ./output/images/rpi-firmware/cmdline.txt

cat $CONF_PATH/interfaces > ./output/target/etc/network/interfaces
cat $CONF_PATH/wpa_supplicant.conf > ./output/target/etc/wpa_supplicant.conf

cat $CONF_PATH/banner.txt > ./output/target/etc/issue

