LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, ncurses/tty) 
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/base) 
LOCAL_SRC_FILES := $(filter-out ncurses/base/lib_driver.c ncurses/base/sigaction.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/tinfo) 
LOCAL_SRC_FILES := $(filter-out ncurses/tinfo/doalloc.c ncurses/tinfo/make_keys.c ncurses/tinfo/tinfo_driver.c, $(LOCAL_SRC_FILES))

LOCAL_SRC_FILES += ncurses/trace/lib_trace.c \
		ncurses/trace/varargs.c \
		ncurses/trace/visbuf.c \
		ncurses/codes.c \
		ncurses/comp_captab.c \
		ncurses/expanded.c \
		ncurses/fallback.c \
		ncurses/lib_gen.c \
		ncurses/lib_keyname.c \
		ncurses/names.c \
		ncurses/unctrl.c \

LOCAL_SRC_FILES := $(sort $(LOCAL_SRC_FILES))
		
LOCAL_CFLAGS := -DHAVE_CONFIG_H -U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 -U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L -DNDEBUG 
LOCAL_CFLAGS += -Wno-unused-parameter

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		$(LOCAL_PATH)/include \
		$(LOCAL_PATH)/ncurses \

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libncurses

include $(BUILD_SHARED_LIBRARY)

#build libpanel
include $(CLEAR_VARS)

LOCAL_SRC_FILES += 	panel/panel.c \
	panel/p_above.c \
	panel/p_below.c \
	panel/p_bottom.c \
	panel/p_delete.c \
	panel/p_hide.c \
	panel/p_hidden.c \
	panel/p_move.c \
	panel/p_new.c \
	panel/p_replace.c \
	panel/p_show.c \
	panel/p_top.c \
	panel/p_update.c \
	panel/p_user.c \
	panel/p_win.c

LOCAL_SRC_FILES := $(sort $(LOCAL_SRC_FILES))
		
LOCAL_CFLAGS := -DHAVE_CONFIG_H -U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 -U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L -DNDEBUG -D_FILE_OFFSET_BITS=64
LOCAL_CFLAGS += -Wno-unused-parameter

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		$(LOCAL_PATH)/include \
		$(LOCAL_PATH)/ncurses \
		$(LOCAL_PATH)/panel \
		$(LOCAL_PATH)/package

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libpanel

LOCAL_SHARED_LIBRARIES := \
    libncurses 
    
include $(BUILD_SHARED_LIBRARY)	

#build libmenu
include $(CLEAR_VARS)

LOCAL_SRC_FILES += 	menu/m_attribs.c \
	menu/m_cursor.c \
	menu/m_driver.c \
	menu/m_format.c \
	menu/m_global.c \
	menu/m_hook.c \
	menu/m_item_cur.c \
	menu/m_item_nam.c \
	menu/m_item_new.c \
	menu/m_item_opt.c \
	menu/m_item_top.c \
	menu/m_item_use.c \
	menu/m_item_val.c \
	menu/m_item_vis.c \
	menu/m_items.c \
	menu/m_new.c \
	menu/m_opts.c \
	menu/m_pad.c \
	menu/m_pattern.c \
	menu/m_post.c \
	menu/m_req_name.c \
	menu/m_scale.c \
	menu/m_spacing.c \
	menu/m_sub.c \
	menu/m_trace.c \
	menu/m_userptr.c \
	menu/m_win.c

LOCAL_SRC_FILES := $(sort $(LOCAL_SRC_FILES))
		
LOCAL_CFLAGS := -DHAVE_CONFIG_H -U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 -U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L -DNDEBUG -D_FILE_OFFSET_BITS=64
LOCAL_CFLAGS += -Wno-unused-parameter

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		$(LOCAL_PATH)/include \
		$(LOCAL_PATH)/ncurses \
		$(LOCAL_PATH)/menu \

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libmenu

LOCAL_SHARED_LIBRARIES := \
    libncurses 
    
include $(BUILD_SHARED_LIBRARY)	

#build libform
include $(CLEAR_VARS)

LOCAL_SRC_FILES += 	form/f_trace.c \
	form/fld_arg.c \
	form/fld_attr.c \
	form/fld_current.c \
	form/fld_def.c \
	form/fld_dup.c \
	form/fld_ftchoice.c \
	form/fld_ftlink.c \
	form/fld_info.c \
	form/fld_just.c \
	form/fld_link.c \
	form/fld_max.c \
	form/fld_move.c \
	form/fld_newftyp.c \
	form/fld_opts.c \
	form/fld_pad.c \
	form/fld_page.c \
	form/fld_stat.c \
	form/fld_type.c \
	form/fld_user.c \
	form/frm_cursor.c \
	form/frm_data.c \
	form/frm_def.c \
	form/frm_driver.c \
	form/frm_hook.c \
	form/frm_opts.c \
	form/frm_page.c \
	form/frm_post.c \
	form/frm_req_name.c \
	form/frm_scale.c \
	form/frm_sub.c \
	form/frm_user.c \
	form/frm_win.c \
	form/fty_alnum.c \
	form/fty_alpha.c \
	form/fty_enum.c \
	form/fty_generic.c \
	form/fty_int.c \
	form/fty_ipv4.c \
	form/fty_num.c \
	form/fty_regex.c

LOCAL_SRC_FILES := $(sort $(LOCAL_SRC_FILES))
		
LOCAL_CFLAGS := -DHAVE_CONFIG_H -U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 -U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L -DNDEBUG -D_FILE_OFFSET_BITS=64
LOCAL_CFLAGS += -Wno-unused-parameter

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
		$(LOCAL_PATH)/include \
		$(LOCAL_PATH)/ncurses \
		$(LOCAL_PATH)/form \

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libform

LOCAL_SHARED_LIBRARIES := \
    libncurses 
    
include $(BUILD_SHARED_LIBRARY)	
# Copy only basic terminal type definitions as ncurses-base in debian does by default.
# http://anonscm.debian.org/gitweb/?p=collab-maint/ncurses.git;a=blob;f=debian/rules;hb=HEAD#l140
TERMINFO_FILES := \
	a/ansi c/cons25 c/cygwin d/dumb E/Eterm E/Eterm-color h/hurd l/linux \
	m/mach m/mach-bold m/mach-color p/pcansi r/rxvt r/rxvt-basic  \
	s/screen s/screen-bce s/screen-s s/screen-w s/sun \
	s/screen-256color s/screen-256color-bce v/vt100 v/vt102 \
	v/vt220 v/vt52 x/xterm x/xterm-xfree86 x/xterm-color x/xterm-r5 x/xterm-r6 \
	x/xterm-vt220 x/xterm-256color w/wsvt25 w/wsvt25m

TERMINFO_SOURCE := $(LOCAL_PATH)/lib/terminfo/
TERMINFO_TARGET := $(TARGET_OUT_ETC)/terminfo
$(TERMINFO_TARGET): $(ACP)
		@echo "copy terminfo to /etc/" 
		@mkdir -p $@
		@$(foreach TERMINFO_FILE,$(TERMINFO_FILES), \
			mkdir -p $@/$(dir $(TERMINFO_FILE)); \
			$(ACP) $(TERMINFO_SOURCE)/$(TERMINFO_FILE) $@/$(TERMINFO_FILE); \
		)
ALL_DEFAULT_INSTALLED_MODULES += $(TERMINFO_TARGET)
