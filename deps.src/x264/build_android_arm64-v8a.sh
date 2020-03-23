#!/bin/bash
#NDK=~/AOSP/NDK/android-ndk-r15c
PLATFORM=$NDK/platforms/android-24/arch-arm64/
TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64
PREFIX=./android/arm64-v8a

function build_one
{
  ./configure \
  --prefix=$PREFIX \
  --enable-static \
  --enable-pic \
  --host=aarch64-linux \
  --cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
  --sysroot=$PLATFORM \
  --extra-cflags="-D__ANDROID__"

  make clean
  make
  make install
}

build_one

echo Android ARM64 builds finished
