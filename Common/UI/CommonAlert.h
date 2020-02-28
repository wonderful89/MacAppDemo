//
//  CommonAlert.h
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VoidCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CommonAlert : NSObject

+ (void)alertWithTitle:(NSString *)title withContent:(NSString *)content;
+ (void)alertWithTitle:(NSString *)title withContent:(NSString *)content withBlcok:(VoidCallBack)block;

@end

NS_ASSUME_NONNULL_END
