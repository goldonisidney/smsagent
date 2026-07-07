THEOS_DEVICE_IP = 192.168.1.100
THEOS_DEVICE_PORT = 22

ARCHS = arm64
TARGET = iphone:15.8.3:15.8.3
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SMSAgent
SMSAgent_FILES = Tweak.xm SMSAgentViewController.m
SMSAgent_FRAMEWORKS = UIKit Foundation Contacts MessageUI
SMSAgent_PRIVATE_FRAMEWORKS = SpringBoardServices

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
