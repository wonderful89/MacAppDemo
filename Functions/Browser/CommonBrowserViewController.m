//
//  CommonBrowserViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "CommonBrowserViewController.h"
#import "CommonAlert.h"
@import WebKit;

@interface CommonBrowserViewController ()<WebUIDelegate, WKNavigationDelegate, NSWindowDelegate>

@property (strong) NSString *initialUrl;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSButton *backButton;
@property (weak) IBOutlet NSButton *forwardButton;

@end

@implementation CommonBrowserViewController

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.initialUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    self.webView.UIDelegate = (id)self;
    self.webView.navigationDelegate = (id)self;
    
//    [self.webView setValue:@(YES) forKey:@"drawsTransparentBackground"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
//    self.webView.wantsLayer = YES;
//    self.webView.layer.backgroundColor = [[NSColor clearColor] CGColor];
    
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        [self keyDown:event];
        return event;
    }];
    if (self.initialUrl){
        self.textField.stringValue = self.initialUrl;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.initialUrl]]];
    } else {
        [self homeClick:nil];
    }
    
}

- (void)viewWillAppear{
//    self.view.window.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshButtons];
        self.webView.wantsLayer = YES;
        self.webView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    });
}

- (void)viewDidAppear{}

- (void)refreshButtons{
    DDLogInfo(@"refreshButtons");
    if (self.webView.canGoBack){
        self.backButton.state = NSControlStateValueOn;
    } else {
        self.backButton.state = NSControlStateValueOff;
    }
    
    if (self.webView.canGoForward){
        self.forwardButton.state = NSControlStateValueOn;
    } else {
        self.forwardButton.state = NSControlStateValueOff;
    }
}

- (IBAction)homeClick:(id)sender {
    DDLogInfo(@"homeClick");
    NSString *url = @"https://qq.com";
    self.textField.stringValue = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (IBAction)goBack:(id)sender {
    DDLogInfo(@"goBack");
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    DDLogInfo(@"goForward");
    [self.webView goForward];
}

- (IBAction)go:(id)sender {
    DDLogInfo(@"go");
    NSString *text = self.textField.stringValue;
    if (text.length == 0){
        [CommonAlert alertWithTitle:@"⚠️" withContent:@"url 不能为空"];
    }
    
    NSString *url = text;
    if (![url hasPrefix:@"http"]){
        url = [NSString stringWithFormat:@"https://%@",text];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - key event

- (void)keyDown:(NSEvent *)event{
//    DDLogInfo(@"event:%d", event.keyCode);
    NSString *eventChars = [event charactersIgnoringModifiers];
    unichar keyChar = [eventChars characterAtIndex:0];

    if (( keyChar == NSEnterCharacter ) ||
        ( keyChar == NSCarriageReturnCharacter )){
        [self go:nil];
    }
}

#pragma mark - delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    DDLogInfo(@"11111");
    NSString *url = navigationAction.request.URL.absoluteString;
    DDLogInfo(@"当前页面的请求URL=%@",url);
    WKNavigationType navitationType = [navigationAction navigationType];
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (navitationType == WKNavigationTypeLinkActivated){
        policy = WKNavigationActionPolicyCancel;
        BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"页面" withController:[[CommonBrowserViewController alloc] initWithUrl:url]];
        [windowController showWindow:nil];
    }
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    DDLogInfo(@"222.当Web内容开始在Web视图中加载时调用");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    WKNavigationResponsePolicy responsePolicy = WKNavigationResponsePolicyAllow;
    DDLogInfo(@"333333");
    decisionHandler(responsePolicy);
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"当Web视图开始接收Web内容时调用");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"导航完成时调用。");
    [self refreshButtons];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    DDLogInfo(@"加载错误时候才调用，错误原因=%@",error);
}

@end
