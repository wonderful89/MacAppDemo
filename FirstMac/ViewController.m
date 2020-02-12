//
//  ViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/12.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(10, 20, 100, 50)];
    [self.view addSubview:view];
    view.wantsLayer = true;
    view.layer.backgroundColor = [[NSColor redColor] CGColor];
    
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(50, 200, 200, 100)];
    button.wantsLayer = true;
    button.layer.backgroundColor = [[NSColor blueColor] CGColor];
    [self.view addSubview:button];
    button.title = @"myButton";
    button.target = self;
    button.action = @selector(buttonClick:);
}

- (void)buttonClick:(id)sender{
    NSLog(@"buttonClicked");
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


@end
