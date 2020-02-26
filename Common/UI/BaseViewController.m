//
//  BaseViewController.m
//  EduPlatformMac
//
//  Created by qianzhao on 2020/2/22.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView{
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0,0,400,400)];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

@end
