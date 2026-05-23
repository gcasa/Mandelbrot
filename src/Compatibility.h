#ifndef MANDELBROT_COMPATIBILITY_H
#define MANDELBROT_COMPATIBILITY_H

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#if defined(__APPLE__)
#define MBPointInRect NSPointInRect
#define MBMinX NSMinX
#define MBMaxX NSMaxX
#define MBMinY NSMinY
#define MBMaxY NSMaxY
#else
#define MBPointInRect NSMouseInRect
#define MBMinX NSMinX
#define MBMaxX NSMaxX
#define MBMinY NSMinY
#define MBMaxY NSMaxY
#endif

#endif
