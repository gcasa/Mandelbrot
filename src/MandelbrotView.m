#import "MandelbrotView.h"
#include <math.h>

static const double MBDefaultMinReal = -2.20;
static const double MBDefaultMaxReal = 0.80;
static const double MBDefaultMinImag = -1.25;
static const double MBDefaultMaxImag = 1.25;

static unsigned char MBClampColor(int value)
{
    if (value < 0) return 0;
    if (value > 255) return 255;
    return (unsigned char)value;
}

@implementation MandelbrotView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maximumIterations = 180;
        _colorMap = MBColorMapClassic;
        [self resetView];
    }
    return self;
}

- (void)dealloc
{
    [_bitmap release];
    [_image release];
    [super dealloc];
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    [self render];
}

- (void)resetView
{
    _minReal = MBDefaultMinReal;
    _maxReal = MBDefaultMaxReal;
    _minImag = MBDefaultMinImag;
    _maxImag = MBDefaultMaxImag;
    _selectionRect = NSZeroRect;
    _dragging = NO;
    [self render];
}

- (void)setColorMap:(MBColorMap)colorMap
{
    _colorMap = colorMap;
    [self render];
}

- (MBColorMap)colorMap
{
    return _colorMap;
}

- (BOOL)hasSelection
{
    return (_selectionRect.size.width > 3.0 && _selectionRect.size.height > 3.0);
}

- (NSString *)coordinateDescription
{
    return [NSString stringWithFormat:@"%.6f .. %.6f, %.6fi .. %.6fi",
        _minReal, _maxReal, _minImag, _maxImag];
}

- (void)colorForIteration:(int)iteration red:(unsigned char *)red green:(unsigned char *)green blue:(unsigned char *)blue
{
    if (iteration >= _maximumIterations) {
        *red = 0;
        *green = 0;
        *blue = 0;
        return;
    }

    switch (_colorMap) {
        case MBColorMapFire:
            *red = MBClampColor(iteration * 7);
            *green = MBClampColor(iteration * 3);
            *blue = MBClampColor(iteration / 2);
            break;
        case MBColorMapIce:
            *red = MBClampColor(iteration / 2);
            *green = MBClampColor(iteration * 4);
            *blue = MBClampColor(80 + iteration * 6);
            break;
        case MBColorMapGray: {
            unsigned char value = MBClampColor(iteration * 255 / _maximumIterations);
            *red = value;
            *green = value;
            *blue = value;
            break;
        }
        case MBColorMapClassic:
        default:
            *red = MBClampColor((iteration * 11) % 256);
            *green = MBClampColor((iteration * 5 + 48) % 256);
            *blue = MBClampColor((iteration * 17 + 96) % 256);
            break;
    }
}

- (void)render
{
    NSRect bounds = [self bounds];
    int width = (int)floor(bounds.size.width);
    int height = (int)floor(bounds.size.height);
    int x, y;

    if (width < 1 || height < 1) {
        return;
    }

    [_bitmap release];
    [_image release];
    _bitmap = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                     pixelsWide:width
                                                     pixelsHigh:height
                                                  bitsPerSample:8
                                                samplesPerPixel:4
                                                       hasAlpha:YES
                                                       isPlanar:NO
                                                 colorSpaceName:NSCalibratedRGBColorSpace
                                                    bytesPerRow:0
                                                   bitsPerPixel:0];
    _image = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];

    for (y = 0; y < height; y++) {
        unsigned char *row = [_bitmap bitmapData] + y * [_bitmap bytesPerRow];
        double ci = _maxImag - ((_maxImag - _minImag) * (double)y / (double)(height - 1));
        for (x = 0; x < width; x++) {
            double cr = _minReal + ((_maxReal - _minReal) * (double)x / (double)(width - 1));
            double zr = 0.0;
            double zi = 0.0;
            int iteration = 0;
            unsigned char red, green, blue;

            while (iteration < _maximumIterations && zr * zr + zi * zi <= 4.0) {
                double nextReal = zr * zr - zi * zi + cr;
                zi = 2.0 * zr * zi + ci;
                zr = nextReal;
                iteration++;
            }

            [self colorForIteration:iteration red:&red green:&green blue:&blue];
            row[x * 4 + 0] = red;
            row[x * 4 + 1] = green;
            row[x * 4 + 2] = blue;
            row[x * 4 + 3] = 255;
        }
    }

    [_image addRepresentation:_bitmap];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor blackColor] set];
    NSRectFill([self bounds]);

    if (_image) {
        [_image drawInRect:[self bounds]
                  fromRect:NSMakeRect(0, 0, [_image size].width, [_image size].height)
                 operation:NSCompositeSourceOver
                  fraction:1.0];
    }

    if ([self hasSelection]) {
        [[NSColor whiteColor] set];
        NSFrameRect(_selectionRect);
        [[NSColor blackColor] set];
        NSFrameRect(NSInsetRect(_selectionRect, 1.0, 1.0));
    }
}

- (NSRect)normalizedRectFromPoint:(NSPoint)a toPoint:(NSPoint)b
{
    CGFloat x = MIN(a.x, b.x);
    CGFloat y = MIN(a.y, b.y);
    CGFloat width = fabs(a.x - b.x);
    CGFloat height = fabs(a.y - b.y);
    return NSMakeRect(x, y, width, height);
}

- (void)mouseDown:(NSEvent *)event
{
    _dragging = YES;
    _dragStart = [self convertPoint:[event locationInWindow] fromView:nil];
    _selectionRect = NSMakeRect(_dragStart.x, _dragStart.y, 0, 0);
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event
{
    NSPoint current = [self convertPoint:[event locationInWindow] fromView:nil];
    NSRect bounds = [self bounds];
    CGFloat aspect = bounds.size.width / bounds.size.height;

    _selectionRect = [self normalizedRectFromPoint:_dragStart toPoint:current];
    if (_selectionRect.size.height > 1.0) {
        _selectionRect.size.width = _selectionRect.size.height * aspect;
        if (current.x < _dragStart.x) {
            _selectionRect.origin.x = _dragStart.x - _selectionRect.size.width;
        }
    }
    _selectionRect = NSIntersectionRect(_selectionRect, bounds);
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)event
{
    _dragging = NO;
    [self mouseDragged:event];
}

- (void)zoomToSelection
{
    NSRect bounds = [self bounds];
    double oldMinReal = _minReal;
    double oldMaxReal = _maxReal;
    double oldMinImag = _minImag;
    double oldMaxImag = _maxImag;

    if (![self hasSelection]) {
        [self render];
        return;
    }

    _minReal = oldMinReal + (oldMaxReal - oldMinReal) * MBMinX(_selectionRect) / bounds.size.width;
    _maxReal = oldMinReal + (oldMaxReal - oldMinReal) * MBMaxX(_selectionRect) / bounds.size.width;
    _maxImag = oldMaxImag - (oldMaxImag - oldMinImag) * MBMinY(_selectionRect) / bounds.size.height;
    _minImag = oldMaxImag - (oldMaxImag - oldMinImag) * MBMaxY(_selectionRect) / bounds.size.height;
    _selectionRect = NSZeroRect;
    [self render];
}

@end
