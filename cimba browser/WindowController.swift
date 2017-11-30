//
//  WindowController.swift
//  cimba browser
//
//  Created by jason on 2017/11/15.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa
import RxSwift

class WindowController: NSWindowController {
    
    @IBOutlet weak var myToolBar: NSToolbar!
    @IBOutlet weak var addDocumentButton: NSButtonCell!
    
    @IBOutlet weak var buttonItem: NSToolbarItem!
    //    var title:NSBindingName?
    let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //shouldCascadeWindows = true 决定了多窗口以瀑布形式展示，默认是新窗口覆盖前窗口
        shouldCascadeWindows = true
//        shouldCloseDocument = false
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        windowCount_G.value += 1
//        Swift.print("windowCount:" + String(windowCount.value))
        
        
//        print("itemCount:" + String(myToolBar.items.count))
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//        self.bind(title!, to: WebViewController.self, withKeyPath: "urlString", options: nil)
        
        
        webViewController.showTitle.asDriver()
            .drive(onNext: { titleString in
//                print("title:"+titleString)
                self.window!.title = titleString
            })
            .disposed(by: disposeBag)
        
        windowCount_G.asDriver()
            .drive(onNext: { count in
                if(count > 1){
                    self.myToolBar.isVisible = false
//                    if(self.myToolBar.items.count>1){
//                        self.myToolBar.removeItem(at: 1)
//                    }
                }else{
                    self.myToolBar.isVisible = true
                }
            })
            .disposed(by: disposeBag)
        
        //恢复全局变量为默认值
        urlString_G = "https://cn.bing.com"
        Swift.print("urlString_G reset")
        
    }
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return winTitle_G
    }
    
//    override func synchronizeWindowTitleWithDocumentName() {
//        super.synchronizeWindowTitleWithDocumentName()
//    }
    
    var viewController: ViewController {
        get {
            return self.window!.contentViewController! as! ViewController
        }
    }
    
    var webViewController: WebViewController {
        get {
            return self.window!.contentViewController!.childViewControllers[0] as! WebViewController
        }
    }

}
