//
//  CommonAlert.m
//  FirstMac
//
//  Created by qianzhao on 2020/2/26.
//  Copyright © 2020 qianzhao. All rights reserved.
//

#import "CommonAlert.h"

@implementation CommonAlert

+ (void)alertWithTitle:(NSString *)title withContent:(NSString *)content{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.icon = [NSImage imageNamed:@"swift"];
    
    //增加一个按钮
    [alert addButtonWithTitle:@"确定"];//1000
    
    //增加一个按钮
    //    [alert addButtonWithTitle:@"NO"];//1001
    //提示的标题
    [alert setMessageText:title];
    //提示的详细内容
    [alert setInformativeText:content];
    //设置告警风格
    [alert setAlertStyle:NSAlertStyleWarning];
    
    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    //开始显示告警
    [alert beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse returnCode){
        //用户点击告警上面的按钮后的回调
    }];
}

+ (void)alertWithTitle:(NSString *)title withContent:(NSString *)content withBlcok:(VoidCallBack)block{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.icon = [NSImage imageNamed:@"swift"];
    
    
    [alert addButtonWithTitle:@"确定"];//1000
    [alert addButtonWithTitle:@"取消"];//1001
    [alert setMessageText:title];
    [alert setInformativeText:content];
    [alert setAlertStyle:NSAlertStyleWarning];
    
    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    [alert beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse returnCode){
        if(returnCode == 1000 && block){
            block();
        }
    }
     ];
}

@end
