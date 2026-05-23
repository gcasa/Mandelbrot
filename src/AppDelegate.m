#import "AppDelegate.h"
#import "MandelbrotView.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSRect frame = NSMakeRect(120, 120, 640, 520);
    NSRect contentBounds = NSMakeRect(0, 0, frame.size.width, frame.size.height);
    NSView *contentView;
    NSButton *runButton;
    NSButton *resetButton;
    NSTextField *label;

    _window = [[NSWindow alloc] initWithContentRect:frame
                                         styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask)
                                           backing:NSBackingStoreBuffered
                                             defer:NO];
    [_window setTitle:@"Mandelbrot"];
    [_window setMinSize:NSMakeSize(420, 330)];

    contentView = [_window contentView];

    _mandelbrotView = [[MandelbrotView alloc] initWithFrame:NSMakeRect(12, 58, contentBounds.size.width - 24, contentBounds.size.height - 70)];
    [_mandelbrotView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [contentView addSubview:_mandelbrotView];
    [_mandelbrotView release];

    runButton = [[NSButton alloc] initWithFrame:NSMakeRect(12, 16, 82, 28)];
    [runButton setTitle:@"RUN"];
    [runButton setBezelStyle:NSRoundedBezelStyle];
    [runButton setTarget:self];
    [runButton setAction:@selector(run:)];
    [runButton setAutoresizingMask:NSViewMaxYMargin];
    [contentView addSubview:runButton];
    [runButton release];

    resetButton = [[NSButton alloc] initWithFrame:NSMakeRect(102, 16, 82, 28)];
    [resetButton setTitle:@"Reset"];
    [resetButton setBezelStyle:NSRoundedBezelStyle];
    [resetButton setTarget:self];
    [resetButton setAction:@selector(reset:)];
    [resetButton setAutoresizingMask:NSViewMaxYMargin];
    [contentView addSubview:resetButton];
    [resetButton release];

    label = [[NSTextField alloc] initWithFrame:NSMakeRect(198, 21, 44, 18)];
    [label setStringValue:@"Colors:"];
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    [label setAutoresizingMask:NSViewMaxYMargin];
    [contentView addSubview:label];
    [label release];

    _colorPopup = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(244, 16, 122, 28) pullsDown:NO];
    [_colorPopup addItemWithTitle:@"Classic"];
    [_colorPopup addItemWithTitle:@"Fire"];
    [_colorPopup addItemWithTitle:@"Ice"];
    [_colorPopup addItemWithTitle:@"Gray"];
    [_colorPopup setTarget:self];
    [_colorPopup setAction:@selector(changeColors:)];
    [_colorPopup setAutoresizingMask:NSViewMaxYMargin];
    [contentView addSubview:_colorPopup];
    [_colorPopup release];

    _statusField = [[NSTextField alloc] initWithFrame:NSMakeRect(378, 20, contentBounds.size.width - 390, 20)];
    [_statusField setBezeled:NO];
    [_statusField setDrawsBackground:NO];
    [_statusField setEditable:NO];
    [_statusField setSelectable:NO];
    [_statusField setAutoresizingMask:(NSViewWidthSizable | NSViewMaxYMargin)];
    [contentView addSubview:_statusField];
    [_statusField release];

    [self updateStatus];
    [_window makeKeyAndOrderFront:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)updateStatus
{
    [_statusField setStringValue:[_mandelbrotView coordinateDescription]];
}

- (void)run:(id)sender
{
    [_mandelbrotView zoomToSelection];
    [self updateStatus];
}

- (void)reset:(id)sender
{
    [_mandelbrotView resetView];
    [self updateStatus];
}

- (void)changeColors:(id)sender
{
    [_mandelbrotView setColorMap:(MBColorMap)[_colorPopup indexOfSelectedItem]];
    [self updateStatus];
}

- (void)showColorMap:(id)sender
{
    NSRunAlertPanel(@"Color Map",
                    @"Choose a predefined color map from the Colors control in the Mandelbrot window.",
                    @"OK",
                    nil,
                    nil);
}

@end
