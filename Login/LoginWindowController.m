//
//  LoginWindowController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/12.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "LoginWindowController.h"
#import "LoginViewController.h"

@interface LoginWindowController ()

@end

@implementation LoginWindowController

- (instancetype)initWithFrame:(NSRect) frame withTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        NSUInteger style = NSTitledWindowMask | NSClosableWindowMask |NSMiniaturizableWindowMask | NSResizableWindowMask;
        NSWindow *window = [[NSWindow alloc]initWithContentRect:frame styleMask:style backing:NSBackingStoreBuffered defer:YES];
        window.title = title;
        self.window = window;
        [self configWindow];
    }
    return self;
}

- (void)configWindow{
    NSWindow *window = self.window;
    //隐藏titleBar透明
    window.titlebarAppearsTransparent = true;
    //隐藏title
    window.titleVisibility = NSWindowTitleHidden;
    //背景白色
    window.backgroundColor = [NSColor whiteColor];
    //隐藏miniaturize按钮
    [window standardWindowButton:NSWindowMiniaturizeButton].hidden = YES;
    //隐藏zoom按钮
    [window standardWindowButton:NSWindowZoomButton].hidden = YES;
    //背景可以移动
    [window setMovableByWindowBackground:YES];
    
    [window setRestorable:false];
    [window center];
    
    self.contentViewController = [[LoginViewController alloc] init];
    NSLog(@"");
}

- (void)loadWindow{
    NSLog(@"loadWindow");
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSLog(@"windowDidLoad");
    
}

@end
