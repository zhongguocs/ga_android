NDK ?= ~/AOSP/NDK/android-ndk-r15c
export $(NDK)

all: prebuilt GA

prebuilt:
	make -C deps.src
GA:
	cd ga/jni && ndk-build
	mkdir -p output/bin/mod && mkdir -p output/lib64
	cp ga/libs/arm64-v8a/lib*.so output/lib64
	find ga/libs/arm64-v8a -type f -not -name "lib*.so" -exec cp {} output/bin/mod \;
	cp ga/libs/arm64-v8a/ga-server-* output/bin
	cp -rf ga/jni/config output/bin
