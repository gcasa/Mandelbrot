#import "Compatibility.h"

typedef enum {
    MBColorMapClassic = 0,
    MBColorMapFire,
    MBColorMapIce,
    MBColorMapGray
} MBColorMap;

@interface MandelbrotView : NSView
{
    NSBitmapImageRep *_bitmap;
    NSImage *_image;
    NSRect _selectionRect;
    NSPoint _dragStart;
    BOOL _dragging;
    double _minReal;
    double _maxReal;
    double _minImag;
    double _maxImag;
    int _maximumIterations;
    MBColorMap _colorMap;
}

- (void)render;
- (void)resetView;
- (void)zoomToSelection;
- (void)setColorMap:(MBColorMap)colorMap;
- (MBColorMap)colorMap;
- (BOOL)hasSelection;
- (NSString *)coordinateDescription;

@end
