NDK ?= ~/AOSP/NDK/android-ndk-r15c
export $(NDK)

all: prebuilt GA

prebuilt:
	make -C deps.src
GA:
	cd ga/jni && ndk-build
	mkdir -p output/bin/mod && mkdir -p output/lib64
	cp ga/libs/arm64-v8a/*.so output/lib64
	cp ga/libs/arm64-v8a/ga-server-periodic output/bin
	cp ga/libs/arm64-v8a/*.so output/bin/mod
	cp -rf ga/jni/config output/bin
