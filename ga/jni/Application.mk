
# Uncomment this if you're using STL in your project
# You can find more information here:
# https://developer.android.com/ndk/guides/cpp-support

APP_CPPFLAGS += -std=c++11
#APP_STL := stlport_static
APP_STL := c++_static
APP_ABI := arm64-v8a

# Min runtime API level
APP_PLATFORM := android-24
