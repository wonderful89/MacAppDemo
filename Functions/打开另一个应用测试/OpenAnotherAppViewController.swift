//
//  OpenAnotherAppViewController.swift
//  FirstMac
//
//  Created by qianzhao on 2020/2/28.
//  Copyright © 2020 qianzhao. All rights reserved.
//

import Cocoa

@objc class OpenAnotherAppViewController: NSViewController {
    
    @IBOutlet weak var button1: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonClick(_ sender: Any) {
        let title = (sender as! NSButton).title
        DDLogInfo("title = \(title)")
        switch title {
        case "MPlayerX":
            DDLogInfo("MPlayerX")
            NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/MPlayerX.app"))
        case "腾讯会议":
            NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/TencentMeeting.app"))
        case "企业云盘":
            let success = NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Qiyeyunpan.app"))
            if (!success) {
                DDLogWarn("云盘不存在")
                let alertStr = """
                在“应用程序”中未找到企业云盘，如已安装请手动启动，
                如需下载安装，请点击下载
                """
                CommonAlert.alert(withTitle: "", withContent: alertStr) {
                    let _ = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["https://yunpan.oa.tencent.com/"])
                };
            }
        case "腾讯会议id":
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.tencent.meeting") else {
                DDLogWarn("没找到url"); return }
            NSWorkspace.shared.open(url)
        case "登月测试":
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.tencent.eduplatform.mac") else { DDLogWarn("没找到url"); return }
            NSWorkspace.shared.open(url)
        case "登月测试-name":
            NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/EduPlatformMac.app"))
        case "照片name":
            NSWorkspace.shared.launchApplication("Photos")
        case "Terminal":
            guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else { return }
            
            let path = "/bin"
            if #available(OSX 10.15, *) {
                let configuration = NSWorkspace.OpenConfiguration()
                configuration.arguments = [path]
                NSWorkspace.shared.openApplication(at: url,
                                                   configuration: configuration,
                                                   completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        case "登月测试3":
            let _ = Process.launchedProcess(launchPath: "/Applications/EduPlatformMac.app/Contents/MacOS/EduPlatformMac", arguments: ["-na"])
        case "echo":
            let _ = Process.launchedProcess(launchPath: "/bin/echo", arguments: ["'echo string print'"])
        case "open":
            let _ = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["/"])
        case "openUrl":
            let _ = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["http://baidu.com"])
        //            let _ = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["/Users/qianzhao/Downloads/"])
        case "openDmg":
            let path = Bundle.main.path(forResource: "idisk_v1.4.3.8", ofType: "dmg")!;
            let task = Process()
            task.launchPath = "/usr/bin/open"
            task.arguments = ["\(path)"]
            task.launch()
        case "openApp":
            let path = Bundle.main.path(forResource: "EduPlatformMac", ofType: "app")!;
            let task = Process()
            task.launchPath = "/usr/bin/open"
            task.arguments = ["\(path)"]
            task.launch()
        default:
            //            NSWorkspace.shared.open(URL(fileURLWithPath: "/Applications/Photos.app"))
            //            let _ = Process.launchedProcess(launchPath: "/bin/date", arguments: ["-j -f '%s' 1377223888"])
            let _ = Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["http://baidu.com"])
        }
    }
}
