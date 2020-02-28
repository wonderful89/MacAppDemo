//
//  MultiTabBrowserViewController.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "MultiTabBrowserViewController.h"
#import "CommonBrowserViewController.h"

@interface MultiTabBrowserViewController ()<NSTabViewDelegate, CommonBrowserViewControllerDelegate>

@property (weak) IBOutlet NSTabView *tabView;
@property (strong) NSMutableArray<CommonBrowserViewController *> *browserViewControllers;

@end

#pragma mark - MultiTabBrowserViewController
@implementation MultiTabBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    self.browserViewControllers = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.tabView.numberOfTabViewItems; i++) {
        NSTabViewItem *item = [self.tabView tabViewItemAtIndex:i];
        item.view.wantsLayer = YES;
        item.view.layer.backgroundColor = [[NSColor whiteColor] CGColor];
        [self configSubView:nil withTabItem:item];
    }
    self.tabView.delegate = self;
}

- (void)configSubView:(NSString *)url withTabItem:(NSTabViewItem *)item{
    CommonBrowserViewController *vc = [CommonBrowserViewController new];
    vc.multiTab = YES;
    vc.delegate = self;
    
    if (![item.label isEqualToString:@"New"]){
        [self.browserViewControllers addObject:vc];
    }
    
    [item.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(item.view);
        make.size.mas_equalTo(item.view);
    }];
}

//添加 item
- (void)addTabItem:(NSString *)url {
    NSString *identifier = [NSString stringWithFormat:@"item%ld", self.tabView.numberOfTabViewItems];
    NSTabViewItem *newItem = [[NSTabViewItem alloc] initWithIdentifier:identifier];
//    newItem.label = identifier;
    newItem.view.wantsLayer = YES;
    newItem.view.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    [self.tabView insertTabViewItem:newItem atIndex:self.tabView.numberOfTabViewItems -1];
    [self.tabView selectTabViewItem:newItem];
    
    [self configSubView:url withTabItem:newItem];
}

//删除 item
- (void)deleteItem:(NSInteger )index {
    if (self.tabView.numberOfTabViewItems > 0) {
        [self.tabView removeTabViewItem:[self.tabView tabViewItemAtIndex:self.tabView.numberOfTabViewItems - 1]];
    }
}

#pragma mark - NSTabViewDelegate

- (void)openNewTab:(NSString *)url{
    DDLogInfo(@"open new tab:%@",url);
    [self addTabItem:url];
}

- (void)updateTitle:(NSString *)title withController:(CommonBrowserViewController *)vc{
    NSInteger index = [self.browserViewControllers indexOfObject:vc];
    NSTabViewItem *item = [self.tabView tabViewItemAtIndex:index];
    item.label = title;
}

- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{
    if (tabViewItem == [self.tabView tabViewItemAtIndex:self.tabView.numberOfTabViewItems - 1]){
        [self addTabItem:nil];
        return NO;
    }
    return YES;
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(nullable NSTabViewItem *)tabViewItem{
    NSLog(@"label: %@", tabViewItem.label);
    NSLog(@"identifier: %@", tabViewItem.identifier);
}

- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)tabView{
    
}

@end
