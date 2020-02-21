//
//  BaseWindowController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/20.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "BaseWindowController.h"

@interface BaseWindowController ()

@end

@implementation BaseWindowController

- (instancetype)initWithTitle:(NSString *)title withController:(NSViewController *)viewController
{
    self = [super init];
    if (self) {
        NSUInteger style = NSTitledWindowMask | NSClosableWindowMask |NSMiniaturizableWindowMask | NSResizableWindowMask;
        NSWindow *window = [[NSWindow alloc]initWithContentRect:CGRectMake(0, 0, 100, 100) styleMask:style backing:NSBackingStoreBuffered defer:YES];
        window.title = title;
        self.window = window;
        [self configWindow];
        self.window.contentViewController = viewController;
    }
    return self;
}

- (void)configWindow{
    NSWindow *window = self.window;
    //隐藏titleBar透明
//    window.titlebarAppearsTransparent = true;
//    //隐藏title
//    window.titleVisibility = NSWindowTitleHidden;
    //背景白色
    window.backgroundColor = [NSColor whiteColor];
    //隐藏miniaturize按钮
//    [window standardWindowButton:NSWindowMiniaturizeButton].hidden = YES;
//    //隐藏zoom按钮
//    [window standardWindowButton:NSWindowZoomButton].hidden = YES;
    //背景可以移动
    [window setMovableByWindowBackground:YES];
    
    [window setRestorable:false];
    [window center];
}

@end
