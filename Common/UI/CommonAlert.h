//
//  CommonAlert.h
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonAlert : NSObject

+ (void)alertWithTitle:(NSString *)title withContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
