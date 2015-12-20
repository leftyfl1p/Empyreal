TARGET = :clang
ARCHS = armv7 armv7s arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Empyreal
Empyreal_FILES = Tweak.xm
Empyreal_FRAMEWORKS = UIKit Foundation
Empyreal_LIBRARIES = applist
Empyreal_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += empyreal
include $(THEOS_MAKE_PATH)/aggregate.mk
