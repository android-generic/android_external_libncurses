#
# Copyright (C) 2021 The Android-x86 Open Source Project
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, distribute
# with modifications, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#

LOCAL_PATH := $(call my-dir)

NCURSES_CFLAGS := -DHAVE_CONFIG_H \
	-U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 \
	-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L \
	-D_FILE_OFFSET_BITS=64 -DNDEBUG -Wno-unused-parameter

# build libncurses
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, ncurses/tty)
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/base)
LOCAL_SRC_FILES := $(filter-out ncurses/base/lib_driver.c ncurses/base/sigaction.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/tinfo)
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/widechar)
LOCAL_SRC_FILES := $(filter-out ncurses/tinfo/doalloc.c ncurses/tinfo/make_keys.c ncurses/tinfo/tinfo_driver.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES += \
	ncurses/trace/lib_trace.c \
	ncurses/trace/varargs.c \
	ncurses/trace/visbuf.c \

LOCAL_CFLAGS := $(NCURSES_CFLAGS)

LOCAL_MODULE := libncurses
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

intermediates := $(call local-generated-sources-dir)

CONFIG_OPTS := --without-ada --without-cxx --without-manpages --without-pkg-config --without-tests --enable-widec --without-gpm
CONFIG_STATUS := $(intermediates)/config.status
$(CONFIG_STATUS): $(LOCAL_PATH)/configure
	@rm -rf $(@D); mkdir -p $(@D)
	export PATH=/usr/bin:/bin:$$PATH; \
	for f in $(<D)/*; do if [ -d $$f ]; then \
		mkdir -p $(@D)/`basename $$f`; ln -sf `realpath --relative-to=$(@D)/d $$f/*` $(@D)/`basename $$f`; \
	else \
		ln -sf `realpath --relative-to=$(@D) $$f` $(@D); \
	fi; done;
	export PATH=/usr/bin:/bin:$$PATH; \
	cd $(@D); ./$(<F) $(CONFIG_OPTS) && $(MAKE) -C include sources && $(MAKE) -C progs tic infocmp && \
	./$(<F) $(CONFIG_OPTS) --prefix=/system --disable-database --with-fallbacks='linux vt100 xterm' \
		--with-tic-path=$$PWD/progs/tic --with-infocmp-path=$$PWD/progs/infocmp || \
		(rm -rf $(@F); exit 1)

GEN_H := $(intermediates)/include/ncurses.h
$(GEN_H): $(CONFIG_STATUS)
	export PATH=/usr/bin:/bin:$$PATH; \
	cd $(@D); $(MAKE) sources; $(MAKE) -C ../ncurses sources
	ln -sf curses.h $@

GEN := $(addprefix $(intermediates)/ncurses/,\
	codes.c \
	comp_captab.c \
	comp_userdefs.c \
	expanded.c \
	fallback.c \
	lib_gen.c \
	lib_keyname.c \
	names.c \
	unctrl.c)

$(GEN): $(GEN_H)

LOCAL_GENERATED_SOURCES := $(GEN)

LOCAL_C_INCLUDES := \
	$(intermediates)/include \
	$(intermediates)/ncurses \

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES) $(LOCAL_PATH)/menu

include $(BUILD_SHARED_LIBRARY)

# build libpanel
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, panel)

LOCAL_CFLAGS := $(NCURSES_CFLAGS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/panel
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES)

LOCAL_MODULE := libpanel
LOCAL_MODULE_TAGS := optional

LOCAL_SHARED_LIBRARIES := libncurses

include $(BUILD_STATIC_LIBRARY)

# build libmenu
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, menu)

LOCAL_CFLAGS := $(NCURSES_CFLAGS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/menu
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES)

LOCAL_MODULE := libmenu
LOCAL_MODULE_TAGS := optional

LOCAL_SHARED_LIBRARIES := libncurses

include $(BUILD_STATIC_LIBRARY)

# build libform
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, form)

LOCAL_CFLAGS := $(NCURSES_CFLAGS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/form
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_C_INCLUDES)

LOCAL_MODULE := libform
LOCAL_MODULE_TAGS := optional

LOCAL_SHARED_LIBRARIES := libncurses

include $(BUILD_STATIC_LIBRARY)
