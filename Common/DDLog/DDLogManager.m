//
//  DDLogManager.m
//  EduPlatformMac
//
//  Created by qianzhao on 2020/2/19.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "DDLogManager.h"

static DDLogManager *_logManager;

@interface DDLogManager ()

@property(nonatomic,strong)DDFileLogger *fileLogger;

@end

@implementation DDLogManager

+ (instancetype)sharedInstance{
 static dispatch_once_t once;
 dispatch_once(&once,^{
    _logManager = [[self alloc] init];
 });
 return _logManager;
}

- (void)setup{
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    [[DDOSLogger sharedInstance] setLogFormatter: [LogFormatter new]];
    
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
//    [[DDTTYLogger sharedInstance] setForegroundColor:[NSColor greenColor] backgroundColor:nil forFlag:DDLogFlagInfo];
    
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger .rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    self.fileLogger .maximumFileSize = 1024 * 1024 * 4;
    [DDLog addLogger:self.fileLogger];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - LogFormatter
@interface LogFormatter ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *modulePrefixString;
@end

@implementation LogFormatter

- (instancetype)initWithModuleString:(NSString *)modeleString
{
    self = [super init];
    if (self) {
        if (modeleString) {
            self.modulePrefixString = modeleString;
        }else{
            self.modulePrefixString = @"DefaultM";
        }

    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modulePrefixString = @"DefaultM";
    }
    return self;
}

/**
 2017-07-24 17:52:45.480 -[AppDelegate application:didFinishLaunchingWithOptions:](AppDelegate:169)(threadId=4856569) [DefaultModule] [Info]thiis i beeg..
 */
// Log File (Debug: Library -> Caches -> Logs)
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{

    [self setFormatter];

    NSString *header = nil;

    switch (logMessage.flag) {

        case DDLogFlagError:
            header = @"[Error]";
            break;
        case DDLogFlagWarning:
            header = @"[Warn]";
            break;
        case DDLogFlagInfo:
            header = @"[Info]";
            break;
        case DDLogFlagDebug:
            header = @"[Debug]";
            break;
        case DDLogFlagVerbose:
            header = @"[Test]";
            break;

        default:
            header = @"[Unknown] ";
            break;
    }

    NSString *format2 = [NSString stringWithFormat:@"(%@:%ld)(t=%@) [%@] %@%@",
//                         [self.dateFormatter stringFromDate:logMessage.timestamp],
//                         logMessage.function,
                         logMessage.fileName,
                         (unsigned long)logMessage.line,
                         logMessage.threadName,
                         self.modulePrefixString,
                         header,
                         logMessage.message];

    return format2;
}

- (void)setFormatter{
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }
}

@end

