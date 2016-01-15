LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libopus 
LOCAL_SRC_FILES = ./libopus.a
 
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE    := RyuOPUS
LOCAL_SRC_FILES := RyuOPUS.c 
LOCAL_LDLIBS    := -lm -llog 

LOCAL_STATIC_LIBRARIES := libopus

LOCAL_CFLAGS := -Wall -DHAVE_MALLOC_H -DHAVE_PTHREAD -finline-functions -frename-registers -ffast-math -s -fomit-frame-pointer

include $(BUILD_SHARED_LIBRARY)