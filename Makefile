TARGET = :clang
ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Empyreal
Empyreal_FILES = Tweak.xm
Empyreal_FRAMEWORKS = UIKit Foundation
Empyreal_LIBRARIES = applist
SHARED_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
