#!/bin/bash

set -e

make kernel
make buildroot
make defconfig
make

