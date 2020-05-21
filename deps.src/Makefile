SDL2_VER := 2.0.12
SDL2_TTF_VER := 2.0.15

PACKAGES := sdl2 sdl2_ttf live555 ffmpeg alsa minicap

all: $(PACKAGES)

sdl2:
	wget -P SDL2 https://www.libsdl.org/release/SDL2-$(SDL2_VER).tar.gz
	tar xzvf SDL2/SDL2-$(SDL2_VER).tar.gz -C SDL2
	cp -rf SDL2/SDL2-$(SDL2_VER)/Android.mk SDL2/SDL2-$(SDL2_VER)/src SDL2/SDL2-$(SDL2_VER)/include SDL2/jni
	cp SDL2/jni/include/SDL_config_android.h SDL2/jni/include/SDL_config.h
	cd SDL2/jni && $(NDK)/ndk-build
	mkdir -p ../prebuilt/lib64 && cp SDL2/libs/arm64-v8a/*.so ../prebuilt/lib64
	mkdir -p ../prebuilt/include/SDL2 && cp -rf SDL2/jni/include/* ../prebuilt/include/SDL2
	rm SDL2/SDL2-$(SDL2_VER).tar.gz

sdl2_ttf:
	wget -P SDL2_ttf https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-$(SDL2_TTF_VER).tar.gz
	tar xzvf SDL2_ttf/SDL2_ttf-$(SDL2_TTF_VER).tar.gz -C SDL2_ttf
	cp -rf SDL2_ttf/SDL2_ttf-$(SDL2_TTF_VER)/external SDL2_ttf/SDL2_ttf-$(SDL2_TTF_VER)/SDL_ttf.c SDL2_ttf/SDL2_ttf-$(SDL2_TTF_VER)/SDL_ttf.h SDL2_ttf/jni
	cd SDL2_ttf/jni && $(NDK)/ndk-build
	cp SDL2_ttf/libs/arm64-v8a/*.so ../prebuilt/lib64
	cp SDL2_ttf/jni/SDL_ttf.h ../prebuilt/include/SDL2
	rm SDL2_ttf/SDL2_ttf-$(SDL2_TTF_VER).tar.gz

.PHONY: live555
live555:
	wget -P live555 http://mirror.sobukus.de/files/src/live555/live.2019.09.30.tar.gz
	tar xzvf live555/live.2019.09.30.tar.gz -C live555
	cp -rf live555/live/BasicUsageEnvironment live555/live/liveMedia live555/live/UsageEnvironment live555/live/groupsock \
		live555/live/mediaServer live555/live/proxyServer live555/jni
	cd live555/jni && $(NDK)/ndk-build
	cp live555/libs/arm64-v8a/*.so ../prebuilt/lib64
	mkdir -p ../prebuilt/include/live555
	find live555/jni -name '*.hh' -exec cp -f {} ../prebuilt/include/live555 \;
	cp -f live555/jni/groupsock/include/NetCommon.h ../prebuilt/include/live555
	rm live555/live.2019.09.30.tar.gz

.PHONY: x264
x264:
	wget -P x264 https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
	tar xjvf x264/x264-master.tar.bz2 -C x264
	cp x264/build_android_arm64-v8a.sh x264/x264-master
	cd x264/x264-master && ./build_android_arm64-v8a.sh
	cp x264/x264-master/android/arm64-v8a/lib/*.a ../prebuilt/lib64
	cp x264/x264-master/android/arm64-v8a/include/* ../prebuilt/include
	rm x264/x264-master.tar.bz2

.PHONY: lame
lame:
	cd lame/jni && $(NDK)/ndk-build
	cp lame/libs/arm64-v8a/*.so ../prebuilt/lib64
	mkdir -p ../prebuilt/include/lame
	cp lame/jni/include/*.h ../prebuilt/include/lame

ffmpeg: x264 lame
	wget -P ffmpeg https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2
	tar xjvf ffmpeg/ffmpeg-4.2.2.tar.bz2 -C ffmpeg
	cp ffmpeg/build_android_arm64-v8a.sh ffmpeg/ffmpeg-4.2.2
	cd ffmpeg/ffmpeg-4.2.2 && patch -p1 < ../patch/0001-Fix-libavformat-udp.c-compile-error.patch && ./build_android_arm64-v8a.sh
	cp ffmpeg/ffmpeg-4.2.2/android/arm64-v8a/lib/*.so ../prebuilt/lib64
	cp -rf ffmpeg/ffmpeg-4.2.2/android/arm64-v8a/include/* ../prebuilt/include
	rm ffmpeg/ffmpeg-4.2.2.tar.bz2

.PHONY: alsa
alsa:
	cd alsa/jni && $(NDK)/ndk-build
	cp alsa/libs/arm64-v8a/*.so ../prebuilt/lib64
	mkdir -p ../prebuilt/include/alsa
	cp -rf alsa/jni/include/* ../prebuilt/include/alsa

.PHONY: minicap
minicap:
	-rm minicap -rf
	git clone https://github.com/openstf/minicap.git
	cp minicap/jni/minicap-shared/aosp/libs/android-25/arm64-v8a/minicap.so ../prebuilt/lib64
	cp minicap/jni/minicap-shared/aosp/include/Minicap.hpp ../prebuilt/include
