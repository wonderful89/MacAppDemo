//
//  CommonBrowserViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "CommonBrowserViewController.h"
#import "CommonAlert.h"
#import "BrowserWebView.h"
#import "FirstMac-Swift.h"

@import WebKit;

static BOOL localPageTest = NO;
static NSString *homeUrl = @"https://docs.qq.com";

@interface CommonBrowserViewController ()<WebUIDelegate, WKNavigationDelegate,
WebFrameLoadDelegate,NSWindowDelegate, NSTextFieldDelegate>

@property (strong) NSString *initialUrl;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *backButton;
@property (weak) IBOutlet NSButton *forwardButton;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong)id monitorId;

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
    self.textField.delegate = (id)self;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    if (localPageTest) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:filePath];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else if (self.initialUrl){
        self.textField.stringValue = self.initialUrl;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.initialUrl]]];
    } else {
        [self homeClick:nil];
    }
    
//    self.monitorId = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
//        [self keyDown:event];
//        return event;
//    }];

    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (WKWebView *)webView{
    if (!_webView){
        NSString *script = @"";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        WKUserContentController *contentController = [WKUserContentController new];
        [contentController addUserScript:userScript];
        WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
        configure.userContentController = contentController;
//        configure.processPool = [BrowserWebView commonProcessPool];
        
//        _webView = [[WKCookieWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:configure useRedirectCookieHandling:YES];
        _webView = [[BrowserWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _webView = [WKWebView new];
        _webView.UIDelegate = (id)self;
        _webView.navigationDelegate = (id)self;
        
        _webView.wantsLayer = YES;
        _webView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    }
    return _webView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        if (object == self.webView){
            DDLogVerbose(@"program= %.2f",self.webView.estimatedProgress);
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView){
            if (self.multiTab){
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateTitle:withController:)]){
                    [self.delegate updateTitle:self.webView.title withController:self];
                }
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    DDLogInfo(@"Common dealloc");
}

- (void)viewWillAppear{
    //    self.view.window.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshButtons];
        self.webView.wantsLayer = YES;
        self.webView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    });
}

- (void)viewDidDisappear{
//    [NSEvent removeMonitor:self.monitorId];
}

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
    NSString *url = homeUrl;
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

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector{
    if (commandSelector == @selector(insertNewline:)){
        [self go:nil];
        return YES;
    }
    return NO;
}

#pragma mark - delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    DDLogInfo(@"11111");
    NSString *url = navigationAction.request.URL.absoluteString;
    DDLogInfo(@"当前页面的请求URL=%@",url);
    WKNavigationType navitationType = [navigationAction navigationType];
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if (navitationType == WKNavigationTypeLinkActivated
        || navitationType == WKNavigationTypeFormSubmitted){
        policy = WKNavigationActionPolicyCancel;
        if (self.multiTab){
            if (self.delegate && [self.delegate respondsToSelector:@selector(openNewTab:)]){
                [self.delegate openNewTab:url];
            } else {
                DDLogWarn(@"没有实现多tab回调");
            }
        } else {
            BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"页面" withController:[[CommonBrowserViewController alloc] initWithUrl:url]];
            [windowController showWindow:nil];
        }
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
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSURL *nsUrl = navigationResponse.response.URL;
    if (nsUrl){
        NSDictionary *headerFields = response.allHeaderFields;
        NSArray<NSHTTPCookie *>*cookies2 = [[NSHTTPCookieStorage sharedHTTPCookieStorage]  cookiesForURL:nsUrl];
        DDLogInfo(@"cookies2 = %@", cookies2);
        NSArray<NSHTTPCookie *>*cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headerFields forURL:nsUrl];
        for(NSHTTPCookie *cookie in cookies){
            if (@available(macOS 10.13, *)) {
                [self.webView.configuration.websiteDataStore.httpCookieStore setCookie:cookie completionHandler:^{
                    DDLogInfo(@"set cookie finished");
                }];
            } else {
                // Fallback on earlier versions
            }
        }
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else {
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"当Web视图开始接收Web内容时调用");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"导航完成时调用。title = %@", webView.title);
    [self refreshButtons];
}

//- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame{
//    DDLogInfo(@"加载错误时候才调用，错误原因 didFailLoadWithError =%@",error);
//}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    DDLogInfo(@"加载错误时候才调用，错误原因 didFailNavigation =%@",error);
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    DDLogInfo(@"加载错误时候才调用，错误原因=%@",error);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"接收服务端重定向");
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    DDLogInfo(@"Web Content处理完结");
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    DDLogInfo(@"createWebViewWithConfiguration");
    if(!navigationAction.targetFrame){
        NSURL *url = navigationAction.request.URL;
        if (self.delegate && [self.delegate respondsToSelector:@selector(openNewTab:)]){
            [self.delegate openNewTab:url.absoluteString];
        }
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSArray<NSURL *> *URLs))completionHandler{
    DDLogInfo(@"runOpenPanelWithParameters");
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    
    openDlg.allowsMultipleSelection = parameters.allowsMultipleSelection;
    if (@available(macOS 10.13.4, *)) {
        [openDlg setCanChooseDirectories:parameters.allowsDirectories];
    } else {
        [openDlg setCanChooseDirectories:NO];
    }
    
    if ([openDlg runModal] == NSModalResponseOK) {
        NSArray* URLs = [openDlg URLs];
        completionHandler(URLs);
        DDLogInfo(@"Webview选择文件");
    } else {
        DDLogInfo(@"取消选择文件");
        completionHandler(nil);
    }
}

- (void)webViewDidClose:(WKWebView *)webView{
    DDLogInfo(@"webViewDidClose");
}


//- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame{
//    DDLogInfo(@"didReceiveTitle=%@",title);
//}
//
//- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame{
//    DDLogInfo(@"didReceiveIcon=%@",image);
//}

@end
