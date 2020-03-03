//
//  BrowserWebView.m
//  EduPlatformMac
//
//  Created by qianzhao on 2020/3/2.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "BrowserWebView.h"

static WKProcessPool *_processPool;
@implementation BrowserWebView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        ;
    }
    return self;
}

+ (WKProcessPool *)commonProcessPool{
    if (!_processPool){
        _processPool = [WKProcessPool new];
    }
    return _processPool ;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    NSString *script = @"";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    WKUserContentController *contentController = [WKUserContentController new];
    [contentController addUserScript:userScript];
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    configure.userContentController = contentController;
    configure.processPool = [BrowserWebView commonProcessPool];
    
    self = [super initWithFrame:frame configuration:configure];
    if (self) {
        ;
    }
    return self;
}

@end
