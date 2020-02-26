//
//  WindowViewController.h
//  FirstMac
//
//  Created by qianzhao on 2020/2/21.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindowViewController : BaseViewController

@end

@interface DebugWindowViewController : NSWindowController

- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
