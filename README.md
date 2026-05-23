# Mandelbrot

A small Objective-C Mandelbrot set explorer for macOS and GNUstep.

The app renders the Mandelbrot set in a resizable window, supports box-select zooming, and includes a few built-in color maps. It is intentionally lightweight: there is no Xcode project, only source files, an app bundle plist, icon assets, and Makefiles.

## Features

- Native AppKit/GNUstep desktop UI
- Drag-to-select zoom region with preserved viewport aspect ratio
- `RUN` button and `Fractal > Run` menu command to zoom into the current selection
- `Reset` button and `Fractal > Reset` menu command to return to the default viewport
- Classic, Fire, Ice, and Gray color maps
- Coordinate range display for the current viewport
- macOS app icon packaged into the `.app` bundle

## Requirements

### macOS

- Xcode Command Line Tools or Xcode
- `make`

### GNUstep

- GNUstep development environment
- `gnustep-make`
- Objective-C compiler and AppKit-compatible GNUstep libraries

## Build

Build for the current platform:

```sh
make
```

Build the macOS app bundle explicitly:

```sh
make macos
```

Build with GNUstep explicitly:

```sh
make gnustep
```

The macOS build output is written to:

```text
build/Mandelbrot.app
```

## Run

On macOS:

```sh
make run
```

Or open the generated app bundle:

```sh
open build/Mandelbrot.app
```

## Usage

1. Drag over the fractal to draw a selection rectangle.
2. Click `RUN` or choose `Fractal > Run` to zoom into that selection.
3. Use `Reset` or `Fractal > Reset` to return to the default view.
4. Use the `Colors` popup to change the rendering palette.

## Project Layout

```text
.
+-- assets/              # Icon source and packaged macOS icon
+-- src/                 # Objective-C application source
+-- Info.plist           # App bundle metadata
+-- Makefile             # macOS/default build
`-- GNUmakefile          # GNUstep build integration
```

## Clean

Remove generated build output:

```sh
make clean
```
