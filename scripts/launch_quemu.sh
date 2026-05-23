#!/bin/bash
cd "$(dirname "$0")"
source build.conf
cd ..

qemu-system-i386 -cdrom ./"$TEMP_DIR"/myos.iso -d int,cpu_reset -no-reboot