export THEOS_DEVICE_IP = 172.17.3.79
export THEOS_DEVICE_USER = root
export THEOS_DEVICE_PASSWORD = alpine
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tweak5

Tweak5_FILES = Tweak.x
Tweak5_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"