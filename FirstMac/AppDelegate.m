//
//  AppDelegate.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/12.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginWindowController.h"

@interface AppDelegate ()

@property(nonatomic, strong)LoginWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSRect frame = CGRectMake(0, 0, 400, 300);
    self.mainWindowController = [[LoginWindowController alloc] initWithFrame:frame withTitle:@"登录"];
//    [self.mainWindowController.window makeKeyAndOrderFront:self];
    [self.mainWindowController showWindow:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
