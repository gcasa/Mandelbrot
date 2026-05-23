#import "Compatibility.h"

@class MandelbrotView;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *_window;
    MandelbrotView *_mandelbrotView;
    NSTextField *_statusField;
    NSPopUpButton *_colorPopup;
}

- (void)run:(id)sender;
- (void)reset:(id)sender;
- (void)changeColors:(id)sender;
- (void)showColorMap:(id)sender;

@end
