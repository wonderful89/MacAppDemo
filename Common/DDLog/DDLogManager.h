//
//  DDLogManager.h
//  EduPlatformMac
//
//  Created by qianzhao on 2020/2/19.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogFormatter : NSObject
<DDLogFormatter>
- (instancetype)initWithModuleString:(NSString *)modeleString;
@end


@interface DDLogManager : NSObject

+ (instancetype)sharedInstance;
- (void)setup;

@end

NS_ASSUME_NONNULL_END
