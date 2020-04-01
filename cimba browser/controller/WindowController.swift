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
    
//    @IBOutlet weak var buttonItem: NSToolbarItem!
    //    var title:NSBindingName?
    let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //shouldCascadeWindows = true 决定了多窗口以瀑布形式展示，默认是新窗口覆盖前窗口
        shouldCascadeWindows = true
//        shouldCloseDocument = false
    }
    
    //该方法会自动被document对象调用，以通知window当前document的状态。传入true就表示document被修改但还未保存
    override func setDocumentEdited(_ dirtyFlag: Bool) {
//        Swift.print("dirtyFlag:"+String(dirtyFlag))
        if(dirtyFlag){
            //强行设置状态，导致self.document.isDocumentEdited 为false      
            self.document?.updateChangeCount(NSDocument.ChangeType.changeCleared)
        }
        super.setDocumentEdited(dirtyFlag)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
//        addButtonToTitleBar()
        
        windowCount_G.accept(NSDocumentController.shared.documents.count)
        
//        Swift.print("windowCount:" + String(windowCount_G.value))
        
        
//        print("itemCount:" + String(myToolBar.items.count))
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//        self.bind(title!, to: WebViewController.self, withKeyPath: "urlString", options: nil)
        
        
        
//        webViewController.showTitle.asDriver
//            .drive(onNext: { titleString in
//                self.window!.title = titleString
//            })
//            .disposed(by: disposeBag)
        
        webViewController.showTitle
             .subscribe(onNext: { titleString in
                 self.window!.title = titleString
             })
             .disposed(by: disposeBag)
        
//        windowCount_G.asDriver()
//            .drive(onNext: { count in
//                if(count > 1){
//                    self.myToolBar.isVisible = false
//                }else{
//                    self.myToolBar.isVisible = true
//                }
//            })
//            .disposed(by: disposeBag)
        windowCount_G
        .subscribe(onNext: { count in
            if(count > 1){
                self.myToolBar.isVisible = false
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
        //Swift.print("displayname:" + displayName)
        // Document实例初始化时的displayName
        return displayName
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
            return self.window!.contentViewController!.children[0] as! WebViewController
        }
    }
    
//    func addButtonToTitleBar(){
//        let titleView = self.window!.standardWindowButton(.closeButton)?.superview
//        let button = NSButton()
//        let x = (self.window!.contentView?.frame.size.width)! - 100
//        let frame = CGRect(x: x, y: 0, width: 80, height: 24)
//        button.frame = frame
//        button.title = "New"
//        button.bezelStyle = .rounded
//        titleView?.addSubview(button)
//    }

}
