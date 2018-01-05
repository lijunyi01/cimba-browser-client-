//
//  AddWLPanel.swift
//  cimba browser
//
//  Created by jason on 2017/12/28.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa

class AddWLPanel: NSPanel {
    
    @IBOutlet weak var infoLabel: NSTextField!
    
    @IBOutlet weak var passwordTF: NSSecureTextField!
    
    @IBAction func cancelAction(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: NSApplication.ModalResponse(rawValue: kCancelCode))
    }
    
    
    @IBAction func okAction(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: NSApplication.ModalResponse(rawValue: kOkCode))
    }
}
