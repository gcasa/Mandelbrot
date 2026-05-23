APP_NAME = Mandelbrot
SOURCES = src/main.m src/AppDelegate.m src/MandelbrotView.m
BUILD_DIR = build
MACOS_APP = $(BUILD_DIR)/$(APP_NAME).app
MACOS_EXE = $(MACOS_APP)/Contents/MacOS/$(APP_NAME)

.PHONY: all macos gnustep clean run

all:
	@if command -v gnustep-config >/dev/null 2>&1; then \
		$(MAKE) gnustep; \
	else \
		$(MAKE) macos; \
	fi

macos: $(MACOS_EXE)

$(MACOS_EXE): $(SOURCES) Info.plist
	@mkdir -p "$(MACOS_APP)/Contents/MacOS"
	@cp Info.plist "$(MACOS_APP)/Contents/Info.plist"
	clang -Wall -Wextra -Wno-deprecated-declarations -fobjc-exceptions -framework Cocoa $(SOURCES) -o "$(MACOS_EXE)"

gnustep:
	$(MAKE) -f GNUmakefile

run: macos
	open "$(MACOS_APP)"

clean:
	rm -rf "$(BUILD_DIR)" obj $(APP_NAME).app
