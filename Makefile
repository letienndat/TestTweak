export THEOS_DEVICE_IP = localhost-iphone
# export THEOS_DEVICE_PORT = 2222
# export THEOS_DEVICE_USER = root
# export THEOS_DEVICE_PASSWORD = alpine
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TestTweak

TestTweak_FILES = Tweak.x
TestTweak_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"