//
//  MainViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/20.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "MainViewController.h"
#import "WindowViewController.h"
#import "ButtonViewController.h"
#import "CommonBrowserViewController.h"
#import "MultiTabBrowserViewController.h"
#import "FirstMac-Swift.h"

@import SafariServices;

static NSString* row1 = @"模态窗口";
static NSString* row1_2 = @"模态窗口2";
static NSString* row2 = @"消失本窗口，弹出新窗口";
static NSString* row3 = @"消失本窗口，弹出新窗口(Window改造)";
static NSString* row4 = @"button样式显示";
static NSString* row5 = @"单TabBrowser";
static NSString* row6 = @"多TabBrowser";
static NSString* row6_2 = @"测试WKWebview";
static NSString* row7 = @"打开另一个应用测试";
static NSString* row8 = @"打开SafariApp";
static NSString* row9 = @"多Tab的window";
static NSString* rowLast = @"Last";

@interface MainViewController ()<NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong)NSScrollView *scrollView;
@property(nonatomic, strong)NSTableView *tableView;
@property(nonatomic, strong)NSArray *items;

@property(nonatomic, strong)NSWindowController *modelWindowController;

@end

#pragma mark - MainViewController
@implementation MainViewController

- (void)viewWillAppear {
    NSLog(@"window3 = %@", self.view.window);
    self.view.window.titleVisibility = NSWindowTitleHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[row1,
                   row1_2,
                   row2,
                   row3,
                   row4,
                   row5,
                   row6,
                   row6_2,
                   row7,
                   row8,
                   row9,
                   rowLast
    ];
    [self.view addSubview:self.scrollView];
    self.scrollView.documentView = self.tableView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.view);
        make.center.mas_equalTo(self.view);
    }];
}

#pragma mark - property

- (NSScrollView *)scrollView{
    if (!_scrollView){
        _scrollView = [NSScrollView new];
        _scrollView.hasVerticalScroller = YES;
        _scrollView.hasHorizontalScroller = YES;
        _scrollView.autohidesScrollers = YES;
        _scrollView.backgroundColor = [NSColor whiteColor];
    }
    return _scrollView;
}

- (NSTableView *)tableView{
    if (!_tableView){
        _tableView = [NSTableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 30;
        _tableView.backgroundColor = [NSColor whiteColor];
        // 隐藏头部
        _tableView.headerView = nil;
        
        NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"列1"];
        column1.resizingMask = NSTableColumnUserResizingMask | NSTableColumnAutoresizingMask;
        [_tableView addTableColumn:column1];
        
    }
    return _tableView;
}

#pragma mark - Delegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSTableView *tableView = notification.object;
    NSLog(@"selection row=%ld, column=%ld", tableView.selectedRow, tableView.clickedColumn);
    
    if (tableView.selectedRow < 0 || tableView.selectedRow > self.items.count - 1){
        return;
    }
    
    NSString *testContent = self.items[tableView.selectedRow];
    if ([testContent isEqualToString:row1]){
        self.modelWindowController = [[BaseWindowController alloc] initWithTitle:@"window" withController:[WindowViewController new]];
        NSWindow *theModalWindow = self.modelWindowController.window;
//        [[NSApplication sharedApplication] runModalForWindow:theModalWindow];
        
        [theModalWindow makeKeyWindow];
        NSInteger retVal = [NSApp runModalForWindow:theModalWindow];
        NSLog(@"retValue = %ld", retVal);
//        [theModalWindow close];
//        //continue and do somethin according the value in retVal
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
        
    } else if ([testContent isEqualToString:row1_2]){
        // 直接close就可以
        [self presentViewControllerAsModalWindow:[WindowViewController new]];
    } else if ([testContent isEqualToString:row2]){
        BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"window" withController:[WindowViewController new]];
        [windowController showWindow:nil];
    } else if ([testContent isEqualToString:row3]){
        // 这样处理为何不响应事件
        DebugWindowViewController *windowController = [[DebugWindowViewController alloc] initWithTitle:@"window"];
        [windowController showWindow:nil];
        //        [windowController.window makeKeyAndOrderFront:nil];
    } else if ([testContent isEqualToString:row4]){
        BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"buttons" withController:[ButtonViewController new]];
        [windowController showWindow:nil];
    } else if ([testContent isEqualToString:row5]){
        BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"browser" withController:[CommonBrowserViewController new]];
        [windowController showWindow:nil];
    } else if ([testContent isEqualToString:row6]){
        BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"browser" withController:[MultiTabBrowserViewController new]];
        [windowController showWindow:nil];
    } else if ([testContent isEqualToString:row6_2]){
        BaseWindowController *windowController = [[BaseWindowController alloc] initWithTitle:@"browser" withController:[WebViewProcess new]];
        [windowController showWindow:nil];
    } else if ([testContent isEqualToString:row7]){
        OpenAnotherAppViewController *vc = [OpenAnotherAppViewController new];
        [self presentViewControllerAsModalWindow:vc];
    } else if ([testContent isEqualToString:row8]){
        [SFSafariApplication openWindowWithURL:[NSURL URLWithString:@"http://docs.qq.com"] completionHandler:^(SFSafariWindow * _Nullable window) {
            DDLogInfo(@"window = %@",window);
        }];
    } else if ([testContent isEqualToString:row9]){
        MuiTabWindowController *windowController = [[MuiTabWindowController alloc] initWithWindowNibName: @"MuiTabWindowController"];
//        [windowController.window makeMainWindow];
//        [windowController.window makeKeyAndOrderFront:self.view.window];
        [windowController showWindow:nil];
//        [self.view.window close];
    }
    
    [self.tableView deselectRow:tableView.selectedRow];
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *contentStr = self.items[row];
    BaseTableCellView *contentView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (!contentView) {
        contentView = [[BaseTableCellView alloc] init];
    }
    
    [contentView configTitle:contentStr];
    return contentView;
}

- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
    NSTableRowView *rowView = [tableView makeViewWithIdentifier:@"rowID" owner:self];
    if(!rowView){
        rowView = [[NSTableRowView alloc] init];
        rowView.identifier = @"rowID";
    }
    return rowView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.items.count;
}

@end
