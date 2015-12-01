TARGET = :clang
ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk

BUNDLE_NAME = empyreal
empyreal_FILES = empyreal.mm
empyreal_INSTALL_PATH = /Library/PreferenceBundles
empyreal_FRAMEWORKS = UIKit Twitter Foundation
empyreal_LIBRARIES = applist
empyreal_PRIVATE_FRAMEWORKS = Preferences
empyreal_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/empyreal.plist$(ECHO_END)
