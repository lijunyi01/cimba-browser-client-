//
//  MyPanel.swift
//  cimba browser
//
//  Created by jason on 2017/12/22.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa

let kCancelCode = 0
let kOkCode = 1

class MyPanel: NSPanel {
    
    @IBOutlet weak var warnLabel: NSTextField!
    
    @IBAction func OkAction(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: NSApplication.ModalResponse(rawValue: kOkCode))
    }
    
    @IBAction func CancelAction(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: NSApplication.ModalResponse(rawValue: kCancelCode))
    }
}
