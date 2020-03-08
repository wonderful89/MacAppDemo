//
//  AppDelegate.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/12.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "WindowViewController.h"
#import "DDLogManager.h"
#import "FirstMac-Swift.h"

@interface AppDelegate ()

@property(nonatomic, strong)NSWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [[DDLogManager sharedInstance] setup];
    self.mainWindowController = [[BaseWindowController alloc] initWithTitle:@"登录页面" withController:[MainViewController new]];
//    self.mainWindowController = [[DebugWindowViewController alloc] initWithTitle:@"测试页面"];
//    self.mainWindowController = [[MuiTabWindowController alloc] initWithWindowNibName:@"MuiTabWindowController"];
    [self.mainWindowController showWindow:self];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (void)newWindowForTab:(id)sender {
    DDLogInfo(@"newWindowForTab2");
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    NSWindowController *controller = keyWindow.windowController;
    DDLogInfo(@"controller = %@", controller);
}


@end
