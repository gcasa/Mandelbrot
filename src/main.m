#import "Compatibility.h"
#import "AppDelegate.h"

static void BuildMenus(id target)
{
    NSMenu *mainMenu;
    NSMenuItem *appItem;
    NSMenu *appMenu;
    NSMenuItem *fractalItem;
    NSMenu *fractalMenu;
    NSMenuItem *colorsItem;
    NSMenu *colorsMenu;

    mainMenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];

    appItem = [[NSMenuItem alloc] initWithTitle:@"Mandelbrot" action:NULL keyEquivalent:@""];
    [mainMenu addItem:appItem];
    appMenu = [[NSMenu alloc] initWithTitle:@"Mandelbrot"];
    [appMenu addItemWithTitle:@"Hide" action:@selector(hide:) keyEquivalent:@"h"];
    [appMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [mainMenu setSubmenu:appMenu forItem:appItem];
    [appMenu release];
    [appItem release];

    fractalItem = [[NSMenuItem alloc] initWithTitle:@"Fractal" action:NULL keyEquivalent:@""];
    [mainMenu addItem:fractalItem];
    fractalMenu = [[NSMenu alloc] initWithTitle:@"Fractal"];
    [[fractalMenu addItemWithTitle:@"Run" action:@selector(run:) keyEquivalent:@"r"] setTarget:target];
    [[fractalMenu addItemWithTitle:@"Reset" action:@selector(reset:) keyEquivalent:@"0"] setTarget:target];
    [mainMenu setSubmenu:fractalMenu forItem:fractalItem];
    [fractalMenu release];
    [fractalItem release];

    colorsItem = [[NSMenuItem alloc] initWithTitle:@"Colors" action:NULL keyEquivalent:@""];
    [mainMenu addItem:colorsItem];
    colorsMenu = [[NSMenu alloc] initWithTitle:@"Colors"];
    [[colorsMenu addItemWithTitle:@"Color Map..." action:@selector(showColorMap:) keyEquivalent:@"m"] setTarget:target];
    [mainMenu setSubmenu:colorsMenu forItem:colorsItem];
    [colorsMenu release];
    [colorsItem release];

    [NSApp setMainMenu:mainMenu];
    [mainMenu release];
}

int main(int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    AppDelegate *delegate;

    (void)argc;
    (void)argv;
    [NSApplication sharedApplication];
    delegate = [[AppDelegate alloc] init];
    BuildMenus(delegate);
    [NSApp setDelegate:delegate];
    [NSApp run];
    [delegate release];
    [pool release];
    return 0;
}
