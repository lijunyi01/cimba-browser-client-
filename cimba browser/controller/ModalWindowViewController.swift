//
//  ModalWindowViewController.swift
//  cimba browser
//
//  Created by jason on 2017/12/6.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa

class ModalWindowViewController: NSViewController {
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var CommitButton: NSButton!
    @IBOutlet weak var passWord: NSSecureTextField!
    @IBOutlet weak var promptTF: NSTextField!
    
//    var rejectDomain:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func cancelPressed(_ sender: NSButton) {
        NSApplication.shared.stopModal()
    }
    
    func setPromptTF(rejectDomain:String){
        promptTF.stringValue = "域名：" + rejectDomain + " 不在允许列表，要添加吗？"
    }
    
}
