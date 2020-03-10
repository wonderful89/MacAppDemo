//
//  WebViewProcess.swift
//  FirstMac
//
//  Created by qianzhao on 2020/3/3.
//  Copyright © 2020 qianzhao. All rights reserved.
//

import Cocoa

@objc class WebViewProcess: NSViewController,feedBack {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var webViewController: NSView!
    var controller2: WebViewController? // 不持有，对象就被释放了
    
    @objc func output() {
        textView.string = outputText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true;
        view.layer?.backgroundColor = NSColor.gray.cgColor
        textView.textColor = NSColor.red;
        let vc = WebViewController()
        controller2 = vc
        webViewController.addSubview(vc.view);
        vc.view.mas_makeConstraints { (make : MASConstraintMaker?) in
            make?.left.mas_equalTo()
            make?.right.mas_equalTo()
            make?.top.mas_equalTo()
            make?.bottom.mas_equalTo()
        };
        
        NotificationCenter.default.addObserver(self, selector: #selector(output), name: NSNotification.Name(rawValue: notifyKeyOutput), object: nil)
        
        vc.delegate = self
        vc.react()
    }
    
    @IBAction func buttonClick(_ sender: NSButton) {
        let title = sender.title;
        print("title = \(title)")
        if (title == "cookie"){
            var contentStr = ""
            let cookies: [HTTPCookie?] = HTTPCookieStorage.shared.cookies ?? [];
            contentStr += "名字 | 值 |  域 | 路径 \n"
            contentStr += "-|-|-|- \n"
            for cookie in cookies {
                var lineStr = ""
                lineStr += cookie?.name ?? ""
                lineStr += " | "
                lineStr += cookie?.domain ?? ""
                lineStr += " | "
                lineStr += cookie?.value ?? ""
                lineStr += " | "
                lineStr += cookie?.path ?? ""
                lineStr += "\n"
                contentStr += lineStr
            }
//            CommonAlert.alert(withTitle: "cookie", withContent: contentStr)
            let vc = MarkdownViewController();
            vc.contentStr = contentStr;
            let windowController = BaseWindowController.init(title: "cookie", with: vc);
            windowController.showWindow(nil);
            
        } else if (title == "other"){
            
        }
    }
}
