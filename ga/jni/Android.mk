LOCAL_PATH := $(call my-dir)

#cmd-strip :=

PREBUILT_PATH := $(LOCAL_PATH)/../../prebuilt

include $(CLEAR_VARS)
LOCAL_MODULE :=  libmp3lame
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libmp3lame.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libavcodec
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libavcodec.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libavdevice
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libavdevice.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libavformat
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libavformat.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libavfilter
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libavfilter.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE :=  libavutil
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libavutil.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE :=  libswresample
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libswresample.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE :=  libswscale
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libswscale.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libpostproc
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libpostproc.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := liblive555
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/liblive555.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include/live555
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libhidapi
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libhidapi.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libSDL2
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libSDL2.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include/SDL2
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libasound
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/libasound.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include/alsa
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libminicap
LOCAL_SRC_FILES := $(PREBUILT_PATH)/lib64/minicap.so
LOCAL_EXPORT_C_INCLUDES := $(PREBUILT_PATH)/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ga
LOCAL_C_INCLUDES := $(LOCAL_PATH)/core/include
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)
LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/core/*.cpp)
LOCAL_CFLAGS += -DGA_MODULE
LOCAL_SHARED_LIBRARIES := libmp3lame libavcodec libavdevice libavfilter libavformat libavutil libswresample libswscale libpostproc
LOCAL_LDLIBS := -llog
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := encoder-video
LOCAL_MODULE_FILENAME := encoder-video
LOCAL_SRC_FILES := module/encoder-video/encoder-video.cpp
LOCAL_C_INCLUDES := $(wildcard module/encoder-video/*.h)
LOCAL_SHARED_LIBRARIES := libavcodec libavutil ga
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := filter-rgb2yuv
LOCAL_MODULE_FILENAME := filter-rgb2yuv
LOCAL_SRC_FILES := module/filter-rgb2yuv/filter-rgb2yuv.cpp
LOCAL_C_INCLUDES := $(wildcard module/filter-rgb2yuv/*.h)
LOCAL_SHARED_LIBRARIES := libswscale ga
#LOCAL_CFLAGS += -fvisibility=hidden
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_CPP_EXTENSION := $(ga_cpp_extension)
LOCAL_MODULE := ctrl-sdl
LOCAL_MODULE_FILENAME := ctrl-sdl
LOCAL_SRC_FILES := module/ctrl-sdl/ctrl-sdl.cpp
LOCAL_C_INCLUDES := $(wildcard module/ctrl-sdl/*.h)
LOCAL_SHARED_LIBRARIES := ga
LOCAL_CFLAGS += -DANDROID -DGA_MODULE
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := vsource-desktop
LOCAL_MODULE_FILENAME := vsource-desktop
LOCAL_SRC_FILES := \
    module/vsource-desktop/vsource-desktop.cpp \
    module/vsource-desktop/ga-androidvideo.cpp
LOCAL_C_INCLUDES := $(wildcard module/vsource-desktop/*.h)
LOCAL_SHARED_LIBRARIES := ga libminicap
LOCAL_CLAGS += -DANDROID
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := encoder-audio
LOCAL_MODULE_FILENAME := encoder-audio
LOCAL_SRC_FILES := module/encoder-audio/encoder-audio.cpp
LOCAL_SHARED_LIBRARIES := libavcodec libavutil libswresample ga
LOCAL_CFLAGS += -DANDROID
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := asource-system
LOCAL_MODULE_FILENAME := asource-system
LOCAL_SRC_FILES := \
    module/asource-system/asource-system.cpp \
    module/asource-system/ga-alsa.cpp
LOCAL_C_INCLUDES := $(wildcard module/asource-system/*.h)
LOCAL_SHARED_LIBRARIES := libasound ga
LOCAL_CFLAGS += -DANDROID -D_POSIX_C_SOURCE=2
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := server-live555
LOCAL_MODULE_FILENAME := server-live555
LOCAL_SRC_FILES := $(wildcard module/server-live555/*.cpp)
LOCAL_C_INCLUDES := $(wildcard module/server-live555/*.h)
LOCAL_SHARED_LIBRARIES := ga liblive555
LOCAL_CFLAGS += -DANDROID
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ga-server-periodic
LOCAL_SRC_FILES := server/periodic/ga-server-periodic.cpp
LOCAL_SHARED_LIBRARIES := libavcodec ga
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := ga-hook-sdl2
LOCAL_MODULE_FILENAME := ga-hook-sdl2
LOCAL_SRC_FILES := \
    server/event-posix/ga-hook-lib.cpp \
    server/event-posix/elf_hook.c \
    server/event-posix/ga-hook-common.cpp \
    server/event-posix/ga-hook-sdl2.cpp \
    server/event-posix/ctrl-sdl.cpp
LOCAL_C_INCLUDES := $(wildcard server/event-posix/*.h)
LOCAL_SHARED_LIBRARIES := ga libhidapi libSDL2
LOCAL_LDLIBS := -lGLESv1_CM -lGLESv2 -lGLESv3
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ga-hook-sdl2audio
LOCAL_MODULE_FILENAME := ga-hook-sdl2audio
LOCAL_SRC_FILES := \
    server/event-posix/ga-hook-lib.cpp \
    server/event-posix/elf_hook.c \
    server/event-posix/ga-hook-common.cpp \
    server/event-posix/ga-hook-sdl2audio.cpp
LOCAL_C_INCLUDES := $(wildcard server/event-posix/*.h)
LOCAL_SHARED_LIBRARIES := ga libhidapi libSDL2 libswresample libavutil
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ga-hook-gl
LOCAL_MODULE_FILENAME := ga-hook-gl
LOCAL_SRC_FILES := \
    server/event-posix/ga-hook-lib.cpp \
    server/event-posix/elf_hook.c \
    server/event-posix/ga-hook-common.cpp \
    server/event-posix/ga-hook-gl.cpp
LOCAL_C_INCLUDES := $(wildcard server/event-posix/*.h)
LOCAL_SHARED_LIBRARIES := ga
LOCAL_LDLIBS := -lGLESv3
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ga-server-event-driven
LOCAL_SRC_FILES := server/event-posix/ga-server-event-driven.cpp
LOCAL_C_INCLUDES := $(wildcard server/event-posix/*.h)
LOCAL_SHARED_LIBRARIES := ga
include $(BUILD_EXECUTABLE)
