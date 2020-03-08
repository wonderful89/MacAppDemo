//
//  MuiTabWindowController.swift
//  FirstMac
//
//  Created by qianzhao on 2020/3/8.
//  Copyright © 2020 qianzhao. All rights reserved.
//

import Cocoa

@objc class MuiTabWindowController: NSWindowController {

//    override func loadWindow() {
//        window = MuiWindow(contentRect: NSMakeRect(0, 0, 400, 400), styleMask: .borderless, backing: .retained, defer: false, screen: nil)
//    }
    override func windowDidLoad() {
        super.windowDidLoad()
        let index = TabManager.shared.windowControllers.count + 1
        window?.title = "window #\(index)"
        window?.tabbingMode = .preferred
        window?.windowController = self
        window?.delegate = self
        TabManager.shared.addWindowController(self)
//        let delay = DispatchTime.now() + 10.0
//        DispatchQueue.main.asyncAfter(deadline: delay) {
//            let window = self.window!
//            DDLogInfo("window = \(window)")
//            let controller = self.window?.windowController!
//            DDLogInfo("window?.windowController = \(String(describing: controller))")
//        }
//        window?.delegate = self as? NSWindowDelegate
//        NSTabViewDelegate
    }

    deinit {
        DDLogInfo("MuiTabWindowController dealloc")
    }
    
}

typealias MuiTabWindowController_delegate = MuiTabWindowController
extension MuiTabWindowController_delegate: NSWindowDelegate{
    
    override func windowWillLoad() {
        DDLogInfo("windowWillLoad")
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        DDLogInfo("windowShouldClose")
        TabManager.shared.removeWindowController(self)
        return true
    }
    
    func windowWillClose(_ notification: Notification) {
        DDLogInfo("windowWillClose")
    }
}

typealias MuiTabWindowController_tab = MuiTabWindowController
extension MuiTabWindowController_tab{
    @IBAction override func newWindowForTab(_ sender: Any?) {
            print("newWindowForTab")
            let windowController = MuiTabWindowController.init(windowNibName: "MuiTabWindowController")
            window?.addTabbedWindow(windowController.window!, ordered: .above)
        }
}
