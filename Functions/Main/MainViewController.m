//
//  MainViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/20.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "MainViewController.h"

static NSString* row1 = @"111";
static NSString* row2 = @"222";
static NSString* row3 = @"333";

@interface MainViewController ()<NSTableViewDelegate, NSTableViewDataSource>

@property(nonatomic, strong)NSScrollView *scrollView;
@property(nonatomic, strong)NSTableView *tableView;
@property(nonatomic, strong)NSArray *items;

@end

#pragma mark - MainViewController
@implementation MainViewController

- (void)loadView{
    NSLog(@"loadView");
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0,0,400,400)];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}

- (void)viewWillAppear {
    NSLog(@"window3 = %@", self.view.window);
    self.view.window.titleVisibility = NSWindowTitleHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = @[row1, row2, row3];
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
        
    } else if ([testContent isEqualToString:row2]){
        
    } else if ([testContent isEqualToString:row3]){
        
    }
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
