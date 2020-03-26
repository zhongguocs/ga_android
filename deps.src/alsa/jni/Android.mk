LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := libasound
LOCAL_MODULE_TAGS := optional

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)

# libasound must be compiled with -fno-short-enums, as it makes extensive
# use of enums which are often type casted to unsigned ints.
LOCAL_CFLAGS := \
	-fPIC -DPIC -D_POSIX_C_SOURCE=2 \
	-DALSA_CONFIG_DIR=\"/system/usr/share/alsa\" \
	-DALSA_PLUGIN_DIR=\"/system/usr/lib/alsa-lib\" \
	-DALSA_DEVICE_DIRECTORY=\"/dev/snd/\" \
	-finline-limit=300 -finline-functions -fno-inline-functions-called-once

#LOCAL_SRC_FILES := $(sort $(call all-c-files-under, src))
LOCAL_SRC_FILES := $(sort $(shell find -L src -name "*.c" -and -not -name ".*"))

# It is easier to exclude the ones we don't want...
#
LOCAL_SRC_FILES := $(filter-out src/alisp/alisp_snd.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/compat/hsearch_r.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/control/control_shm.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/pcm/pcm_d%.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/pcm/pcm_ladspa.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/pcm/pcm_shm.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/pcm/scopes/level.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out src/shmarea.c, $(LOCAL_SRC_FILES))

$(warning "the value of LOCAL_SRC_FILES is$(LOCAL_SRC_FILES)")

include $(BUILD_SHARED_LIBRARY)
