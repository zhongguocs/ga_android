LOCAL_PATH := $(call my-dir)  

include $(CLEAR_VARS)  
  
LOCAL_MODULE := live555

SOURCE_LIST := $(wildcard $(LOCAL_PATH)/BasicUsageEnvironment/*.cpp)
SOURCE_LIST += $(wildcard $(LOCAL_PATH)/groupsock/*.cpp)
SOURCE_LIST += $(wildcard $(LOCAL_PATH)/groupsock/*.c)
SOURCE_LIST += $(wildcard $(LOCAL_PATH)/liveMedia/*.cpp)
SOURCE_LIST += $(wildcard $(LOCAL_PATH)/liveMedia/*.c)
SOURCE_LIST += $(wildcard $(LOCAL_PATH)/UsageEnvironment/*.cpp)

LOCAL_SRC_FILES := $(SOURCE_LIST)

LOCAL_C_INCLUDES := \
    BasicUsageEnvironment/include \
    liveMedia/include \
    groupsock/include \
    UsageEnvironment/include  
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)
LOCAL_CPP_FEATURES := exceptions rtti
#LOCAL_CPPFLAGS += -fexceptions -frtti -DXLOCALE_NOT_USED=1 -DNULL=0 -DNO_SSTREAM=1 -DSOCKLEN_T=socklen_t -UIP_ADD_SOURCE_MEMBERSHIP
LOCAL_CFLAGS += -DNO_SSTREAM=1 -DSOCKLEN_T=socklen_t -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64 -DANDROID_OLD_NDK

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)
LOCAL_MODULE := live555ProxyServer
SOURCE_LIST := $(wildcard $(LOCAL_PATH)/proxyServer/*.cpp)
LOCAL_SRC_FILES := $(SOURCE_LIST)
LOCAL_C_INCLUDES := proxyServer/include
LOCAL_SHARED_LIBRARIES := live555
#LOCAL_CPPFLAGS += -fPIC -fPIE
#LOCAL_LDFLAGS += -pie
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := live555MediaServer
SOURCE_LIST := $(wildcard $(LOCAL_PATH)/mediaServer/*.cpp)
LOCAL_SRC_FILES := $(SOURCE_LIST)
LOCAL_C_INCLUDES := mediaServer/include
LOCAL_SHARED_LIBRARIES := live555
#LOCAL_CPPFLAGS += -fPIC -fPIE
#LOCAL_LDFLAGS += -pie
include $(BUILD_EXECUTABLE)
