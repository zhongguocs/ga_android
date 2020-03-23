LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := mp3lame
LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/src/*.c)
LOCAL_C_INCLUDES := $(wildcard $(LOCAL_PATH)/src/*.h) $(LOCAL_PATH)/include
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_CFLAGS += -DSTDC_HEADERS
include $(BUILD_SHARED_LIBRARY)
