//
//  WarnPanel.swift
//  cimba browser
//
//  Created by jason on 2017/12/29.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa

class WarnPanel: NSPanel {
    @IBOutlet weak var infoLabel: NSTextField!
    
    @IBAction func okAction(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: NSApplication.ModalResponse(rawValue: kOkCode))
    }
}
