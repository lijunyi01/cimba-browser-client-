//
//  ViewController.swift
//  cimba browser
//
//  Created by jason on 2017/11/15.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa
import WebKit

let notifyKeyOutput = "output"

var outputText = "Welcome.\n"

class ViewController: NSViewController,feedBack {
    
    
    @IBOutlet var myTextView: NSTextView!
    
    let webViewController = WebViewController()
    
    @objc func output() {
        myTextView.string = outputText
    }  // end func

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(output), name: NSNotification.Name(rawValue: notifyKeyOutput), object: nil)
        outputText += "ViewController View loaded.\n"
        output()
        // register delegation
        webViewController.delegate = self
        webViewController.react()
        Swift.print("view did load")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

