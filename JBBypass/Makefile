ARCHS = arm64
TARGET = iphone:clang:15.8.3:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = JBBypass
JBBypass_FILES = Tweak.xm
JBBypass_FRAMEWORKS = UIKit Foundation

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
