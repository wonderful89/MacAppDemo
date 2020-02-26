//
//  WindowViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/21.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "WindowViewController.h"
@import WebKit;

@interface WindowViewController ()<NSWindowDelegate>

@property(nonatomic, strong)NSButton *button;

@end

@implementation WindowViewController

- (void)viewWillAppear {
    NSLog(@"window3 = %@", self.view.window);
    self.view.window.titleVisibility = NSWindowTitleHidden;
    self.view.window.delegate = self;
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
}

- (void)viewDidLoad {
    [self.view addSubview:self.button];
}

- (NSButton *)button{
    if(!_button){
        if (@available(macOS 10.12, *)) {
            _button = [NSButton buttonWithTitle:@"测试" target:self action:@selector(buttonClick:)];
        } else {
            // Fallback on earlier versions
        }
    }
    return _button;
}


- (void)buttonClick:(id)sender{
    NSLog(@"buttonClick 11");
    NSLog(@"self.window.modalPanel = %d", self.view.window.modalPanel);
    NSLog(@"self.window.isModalPanel = %d", self.view.window.isModalPanel);
    if (self.view.window.modalPanel){
        if ([NSApp modalWindow] == self.view.window){
            [NSApp stopModal];
        }
    } else {
        [self.view.window close];
    }
}

#pragma mark - event
- (void)mouseDown:(NSEvent *)event{
    NSLog(@"mouseDown: %@", event);
}

- (void)mouseUp:(NSEvent *)event{
    NSLog(@"mouseUp: %@", event);
}

- (void)mouseMoved:(NSEvent *)event{
    NSLog(@"mouseMoved: %@", event);
}

- (BOOL)windowShouldClose:(NSWindow *)sender{
    return YES;
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize{
    return frameSize;
}

- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame{
    return NO;
}

@end

#pragma mark - DebugWindowViewController

@interface DebugWindowViewController ()

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)NSButton *button;

@end

@implementation DebugWindowViewController

- (instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
        NSWindow *window = [[NSWindow alloc]initWithContentRect:CGRectMake(0, 0, 400, 400) styleMask:style backing:NSBackingStoreBuffered defer:YES];
        window.title = title;
        self.window = window;
        [self configWindow];
    }
    return self;
}

- (void)configWindow{
    NSWindow *window = self.window;
    //隐藏titleBar透明
//    window.titlebarAppearsTransparent = true;
    //隐藏title
//    window.titleVisibility = NSWindowTitleHidden;
    //背景白色
    window.backgroundColor = [NSColor whiteColor];
    //隐藏miniaturize按钮
    [window standardWindowButton:NSWindowMiniaturizeButton].hidden = YES;
    //隐藏zoom按钮
    [window standardWindowButton:NSWindowZoomButton].hidden = YES;
    //背景可以移动
    [window setMovableByWindowBackground:YES];
    
    [window setRestorable:false];
    [window center];
    
    [window becomeFirstResponder];
    
    NSView *view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    window.contentView = view;
    view.wantsLayer = YES;
    view.layer.backgroundColor = [[NSColor blueColor] CGColor];
    
//    window.contentView = self.webView;
    if (@available(macOS 10.12, *)) {
        self.button = [NSButton buttonWithTitle:@"加载" target:self action:@selector(buttonClick:)];
    } else {
        // Fallback on earlier versions
    }
    [window.contentView addSubview:self.button];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
}

- (void)buttonClick:(id)sender{
    NSLog(@"buttonCLick: 111");
    NSLog(@"self.window.modalPanel = %d", self.window.modalPanel);
    NSLog(@"self.window.isModalPanel = %d", self.window.isModalPanel);
    if (self.window.isModalPanel){
        
    }
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
}

- (WKWebView *)webView{
    if (!_webView){
        _webView = [[WKWebView alloc] init];
//        _webView.UIDelegate = (id)self;
//        _webView.navigationDelegate = self;
        _webView.wantsLayer = YES;
        _webView.layer.backgroundColor = [[NSColor redColor] CGColor];
        _webView.frame = self.window.frame;//CGRectMake(0, 0, 800, 800);
        _webView.frame = CGRectMake(0, 0, 400, 400);
        //        NSString *url = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/qrconnect?appid=%@&redirect_uri=%@&response_type=code&scope=snsapi_login&state=STATE#wechat_redirect", kAppId, kCallbackUrl];
        NSString *url = @"https://eduplatform.translator.qq.com/static/wechat/index.html";
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        
//        [_webView addSubview:self.button];
    }
    return _webView;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

#pragma mark - event
- (void)mouseDown:(NSEvent *)event{
    NSLog(@"mouseDown: %@", event);
}

- (void)mouseUp:(NSEvent *)event{
    NSLog(@"mouseUp: %@", event);
}

- (void)mouseMoved:(NSEvent *)event{
    NSLog(@"mouseMoved: %@", event);
}

@end
