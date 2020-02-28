//
//  CommonBrowserViewController.h
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class CommonBrowserViewController;

@protocol CommonBrowserViewControllerDelegate <NSObject>

@optional
- (void)openNewTab:(NSString *)url;
- (void)updateTitle:(NSString *)title withController:(CommonBrowserViewController *)vc;

@end

#pragma mark - CommonBrowserViewController
@interface CommonBrowserViewController : NSViewController

@property(assign)BOOL multiTab;
@property(weak)id<CommonBrowserViewControllerDelegate> delegate;

- (instancetype)initWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
