//
//  BaseTableCellView.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/21.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "BaseTableCellView.h"

@interface BaseTableCellView ()

@property(nonatomic, strong)NSTextField *myTextField;

@end

@implementation BaseTableCellView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.myTextField = [[NSTextField alloc] init];
        self.myTextField.textColor = [NSColor whiteColor];
        self.myTextField.editable = NO;
        self.myTextField.bordered = NO;
        self.myTextField.font = [NSFont systemFontOfSize:14];
        self.myTextField.backgroundColor = [NSColor clearColor];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [[NSColor grayColor] CGColor];
        self.myTextField.alignment = NSTextAlignmentLeft;
        if (@available(macOS 10.11, *)) {
            self.myTextField.maximumNumberOfLines = 1;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:self.myTextField];
        
        [self.myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(self);
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)configTitle:(NSString *)title{
    self.myTextField.stringValue = title;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

@end
