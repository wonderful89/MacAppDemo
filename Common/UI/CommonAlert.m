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
    [alert addButtonWithTitle:@"OK"];//1000
    
    //增加一个按钮
//    [alert addButtonWithTitle:@"NO"];//1001
    //提示的标题
    [alert setMessageText:@"提示的标题"];
    //提示的详细内容
    [alert setInformativeText:@"提示的详细内容"];
    //设置告警风格
    [alert setAlertStyle:NSAlertStyleWarning];
    
    NSWindow *window = [[NSApplication sharedApplication] keyWindow];
    //开始显示告警
    [alert beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse returnCode){
                      //用户点击告警上面的按钮后的回调
                      NSLog(@"returnCode : %ld",returnCode);
                  }
     ];
}

@end
