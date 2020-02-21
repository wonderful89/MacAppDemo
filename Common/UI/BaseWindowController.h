//
//  BaseWindowController.h
//  FirstMac
//
//  Created by qianzhao on 2020/2/20.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseWindowController : NSWindowController

- (instancetype)initWithTitle:(NSString *)title withController:(NSViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
