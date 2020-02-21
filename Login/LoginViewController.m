//
//  LoginVIewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/12.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)loadView{
    NSLog(@"loadView");
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0,0,400,400)];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (void)viewWillAppear {
    NSLog(@"window3 = %@", self.view.window);
    self.view.window.titleVisibility = NSWindowTitleHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
}

@end
