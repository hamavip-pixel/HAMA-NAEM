TARGET := iphone:clang:latest:14.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = ShadowTrackerExtra

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HamaPubgHub
HamaPubgHub_FILES = main.xm
HamaPubgHub_FRAMEWORKS = UIKit Foundation QuartzCore

include $(THEOS)/makefiles/tweak.mk
