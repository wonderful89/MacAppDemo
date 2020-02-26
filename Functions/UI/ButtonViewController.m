//
//  ButtonViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/25.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()

@property (weak) IBOutlet NSButton *button1;
@property (weak) IBOutlet NSButton *button2;
@property (weak) IBOutlet NSPopUpButton *popUpButton;
@property (weak) IBOutlet NSButton *checkBox1;
@property (weak) IBOutlet NSButton *radio1;
@property (weak) IBOutlet NSButton *upload1;
@property (assign) NSInteger count;
@property (weak) IBOutlet NSTextField *label;

@end

@implementation ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    self.button1.title = @"button1";
}

- (IBAction)pushButtonClick:(id)sender {
    NSLog(@"pushButtonClick");
}

- (IBAction)textbuttonClick:(id)sender {
    NSLog(@"textbuttonClick");
}

- (IBAction)popUpButtonClick:(id)sender {
    NSLog(@"popUpButtonClick");
}

- (IBAction)checkBoxClick:(id)sender {
    NSLog(@"checkBoxClick");
}

- (IBAction)radioClick:(id)sender {
    NSLog(@"radioClick");
}

- (IBAction)upArrowClick:(id)sender {
    NSLog(@"upArrowClick");
}

- (IBAction)increaseClick:(id)sender {
    self.count ++;
    self.label.stringValue = [NSString stringWithFormat:@"%ld",self.count];
}


@end
