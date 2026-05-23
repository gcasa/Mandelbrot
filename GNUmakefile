ifeq ($(GNUSTEP_MAKEFILES),)
include Makefile
else
include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = Mandelbrot
Mandelbrot_OBJC_FILES = src/main.m src/AppDelegate.m src/MandelbrotView.m
Mandelbrot_RESOURCE_FILES = Info.plist
Mandelbrot_APPLICATION_ICON =
Mandelbrot_GUI_LIBS += -lm

include $(GNUSTEP_MAKEFILES)/application.make
endif
