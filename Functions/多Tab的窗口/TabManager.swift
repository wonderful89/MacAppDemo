//
//  TabManager.swift
//  FirstMac
//
//  Created by qianzhao on 2020/3/9.
//  Copyright © 2020 qianzhao. All rights reserved.
//

import Cocoa

class TabManager {
    var windowControllers: [NSWindowController] = []
    
    static let shared: TabManager = {
        let instance = TabManager()
        // setup code
        return instance
    }()
    
    func addWindowController(_ windowController: NSWindowController){
        windowControllers.append(windowController)
    }
    
    func isEmpty() -> Bool{
        return windowControllers.isEmpty
    }
    
    func removeWindowController(_ windowController: NSWindowController){
        windowControllers.removeAll { (controler) -> Bool in
            return windowController == controler
        }
    }
}
