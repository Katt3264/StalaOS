#!/bin/bash
cd "$(dirname "$0")"
source build.conf
cd ..

set -e # stop on error

rm -rf "$TEMP_DIR"
mkdir "$TEMP_DIR"


./stala_x86_32 kernel/kernel.stala -out "$TEMP_DIR"/StalaKernel.asm


nasm -f bin boot/boot_sector.asm -o "$TEMP_DIR"/boot_sector.bin

dd if=/dev/zero of="$TEMP_DIR"/floppy.img bs=1024 count=1440
dd if="$TEMP_DIR"/boot_sector.bin of="$TEMP_DIR"/floppy.img conv=notrunc
mkisofs -quiet -V 'MYOS' -input-charset iso8859-1 -o "$TEMP_DIR"/myos.iso -b floppy.img -hide floppy.img "$TEMP_DIR"/