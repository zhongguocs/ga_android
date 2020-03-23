#!/bin/bash
#Change NDK to your Android NDK location
NDK=~/AOSP/NDK/android-ndk-r15c
PLATFORM=$NDK/platforms/android-24/arch-arm64/
PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

GENERAL="\
--enable-pic \
--enable-cross-compile \
--arch=aarch64 \
--cc=$PREBUILT/bin/aarch64-linux-android-gcc \
--cross-prefix=$PREBUILT/bin/aarch64-linux-android- \
--nm=$PREBUILT/bin/aarch64-linux-android-nm \
--extra-cflags="-I../../../prebuilt/include" \
--extra-ldflags="-L../../../prebuilt/lib64" "

MODULES="\
--enable-gpl \
--enable-libx264 \
--enable-libmp3lame"

function build_arm64
{
  ./configure \
  --logfile=conflog.txt \
  --target-os=android \
  --prefix=./android/arm64-v8a \
  ${GENERAL} \
  --sysroot=$PLATFORM \
  --enable-shared \
  --disable-static \
  --disable-doc \
  --enable-zlib \
  --extra-cflags="-D__ANDROID__ -DANDROID_OLD_NDK" \
  ${MODULES}

  make clean
  make
  make install
}

build_arm64


echo Android ARM64 builds finished

#--extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
