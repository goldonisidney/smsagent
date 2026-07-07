THEOS_DEVICE_IP = 192.168.118.5
THEOS_DEVICE_PORT = 22

THEOS_PACKAGE_SCHEME = rootless

ARCHS = arm64
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FontChanger
FontChanger_FILES = Tweak.xm
FontChanger_FRAMEWORKS = UIKit CoreText

APPLICATION_NAME = FontChangerApp
FontChangerApp_FILES = main.m AppDelegate.m FontChangerViewController.m
FontChangerApp_FRAMEWORKS = UIKit CoreText

include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/application.mk

after-install::
	install.exec "killall -9 SpringBoard"
