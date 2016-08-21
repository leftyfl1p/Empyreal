TARGET = :clang
ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = empyreal
empyreal_FILES = empyreal.mm
empyreal_INSTALL_PATH = /Library/PreferenceBundles
empyreal_FRAMEWORKS = UIKit Social Foundation
empyreal_LIBRARIES = applist
empyreal_PRIVATE_FRAMEWORKS = Preferences
empyreal_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/empyreal.plist$(ECHO_END)
