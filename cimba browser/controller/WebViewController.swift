//
//  WebViewController.swift
//  WKWebView
//
//  Created by Marco Barnig on 17/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa
import WebKit
import RxSwift
import RxCocoa

//import Moya
//import Alamofire

//let kCancelCode = 0
//let kOkCode = 1

class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSTextFieldDelegate {
    
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var GoButton: NSButton!
    @IBOutlet weak var mySlider: NSSlider!
    //    var myWebView: WKWebView?
    var delegate: feedBack?
    
//    var whiteList = Array<String>()
    
    var showTitle: Variable<String> = Variable("cn.bing.com")
    
    let disposeBag = DisposeBag()
    
//    func setUrlString(url:String){
//        if(url.isEmpty || url.contains(" ")){
//            urlString = "https://cn.bing.com"
//        }else{
//            urlString = url
//        }
//    }
    
    func output(item: AnyObject) {
        outputText += "ScrollView : " + String(describing: item.scrollView)
        outputText += "Title : " + String(describing: item.title)
        // print("URL : " + String(item.url)!) // crash
        outputText += "UserAgent : " + String(describing: item.customUserAgent)
        outputText += "serverTrust : " + String(describing: item.serverTrust)
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let urlString = String(describing: webView.url!)
        outputText += "1. The web content is loaded in the WebView. url: \(urlString) \n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
        
        progressIndicator.startAnimation(nil)
//        GoButton.isEnabled = false
        GoButton.title = "Stop!"
        
        //add by ljy
//        if(isDropUrl(urlStr:urlString)){
//            let myURL = URL(string: "https://cn.bing.com")
//            let myRequest = URLRequest(url: myURL!)
//            myWebView.load(myRequest)
//            //显示提示窗口，告知哪个域不被允许
////            showModalWindow(domain: getDomain(fromUrlStr: urlString))
//            let domainToVisit = getDomain(fromUrlStr: urlString)
//            let warnString = "您要访问的域：[" + domainToVisit + "] 不被允许，需要添加进白名单吗？"
//            showModalPanel(domain: domainToVisit ,warnString: warnString)
//        }
        
        urlTextField.stringValue = urlString
    }  // end func
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let urlString = String(describing: webView.url!)
        outputText += "2. The WebView begins to receive web content. url: \(urlString) \n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
    }  // end func
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let urlString = String(describing: webView.url!)
        outputText += "3. The navigating to url \(urlString) finished.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
        progressIndicator.stopAnimation(nil)
//        GoButton.isEnabled = true
        GoButton.title = "Go!"
    }  // end func
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        outputText += "The Web Content Process is finished.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        outputText += "An error didFail occured.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        outputText += "An error didFailProvisionalNavigation occured.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        outputText += "The WebView received a server redirect.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)    
    }  // end func
    
    //请求拦截
    func webView(_ webView: WKWebView,decidePolicyFor navigationAction: WKNavigationAction,decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)){

        let urlString = String(describing: webView.url!)

        if(isDropUrl(urlStr:urlString)){
//            decisionHandler(.cancel)
            let domainToVisit = getDomain(fromUrlStr: urlString)
            let warnString = "您要访问的域：[" + domainToVisit + "] 不被允许，需要添加进白名单吗？"
            showModalPanel(domain: domainToVisit ,warnString: warnString)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
    }
    
    
    //涉及从页面跳转到新窗口打开
    // the following function handles target="_blank" links by opening themmin thesame view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        outputText += "New Navigation.\n"
        if navigationAction.targetFrame == nil {
            outputText += "Trial to open a blank window.\n"
            outputText += "navigationAction : " + String(describing: navigationAction) + ".\n"
            let newLink = navigationAction.request
            let urlString = String(describing: newLink.url!)
            outputText += "\nThe new navigationAction is : " + String(describing: navigationAction) + ".\n\n"
            outputText += "The new URL is : " + urlString + ".\n"
            NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
            openUrlInNewTab(link: newLink.url!)
    
        }  // end if
        return nil
    } // end func
    
    
    //这里应该实现新开窗口显示页面！！！
    func openUrlInNewTab(link: URL) {
        
        urlString_G = link.absoluteString
        let documentController = NSDocumentController.shared
        documentController.newDocument(nil)
        
//        showTitle.value = getDomain(fromUrlStr:urlString)
//        let myRequest = URLRequest(url: link)
//        myWebView?.load(myRequest)
    }  // end func
    
    func react() {
        outputText += "\nHi. How are you? Here is the \"dummy\" react function speaking!\n\n"
        if let doAction = delegate { 
            DispatchQueue.main.async() { 
                doAction.output()
            }  // end dispatch
        } // end if doAction        
    }  // end func

    //新开窗口会调用到这里，打开全局变量对应的网址（可能是点击加号打开默认首页，也可能是从某网页跳转过来打开特定网址）
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!whiteList_G.contains("bing.com")){
            whiteList_G.append("bing.com")
        }
        
        // Do view setup here.
        outputText += "0. WebViewController View loaded.\n"
        NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        urlTextField.delegate = self
        // NSButton的一种效果
//        GoButton.showsBorderOnlyWhileMouseInside = true
        
        view.addSubview(myWebView)
        Swift.print("urlString_G:"+urlString_G)
        let myURL = URL(string: urlString_G)
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
//        winTitle_G = getDomain(fromUrlStr:urlString_G)
//        Swift.print("set title:"+winTitle_G)
        
        //允许缩放
        myWebView.allowsMagnification = true
//        myWebView.setMagnification(3.0, centeredAt: CGPoint(x:0.0,y:0.0))
        
        //添加观察者
        myWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: NSKeyValueObservingOptions.new, context: nil)
        
    }  // end func
    
    //释放观察者
    override func viewWillDisappear() {
        myWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        super.viewWillDisappear()
        
        //为了释放内存
//        myWebView.navigationDelegate = nil
//        myWebView.uiDelegate = nil
//        urlTextField.delegate = nil
    }
    
    //实现观察
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (object as? WKWebView) != nil {
            if(keyPath == "title"){
                if let webTitle = myWebView.title {
                    self.showTitle.value = webTitle
                }else {
                    self.showTitle.value = "untitled"
                }
            }else{
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    
    func viewReLoad(newUrl:String) {
        if(!(newUrl.isEmpty || newUrl=="")){
            let newUrl2:String
            if(!newUrl.starts(with: "http")){
                newUrl2 = "https://" + newUrl
            }else{
                newUrl2 = newUrl
            }
            
//            setUrlString(url: newUrl2)
            //urlString = newUrl2
            let myURL = URL(string: newUrl2)
            let myRequest = URLRequest(url: myURL!)
            myWebView.load(myRequest)
            
            showTitle.value = getDomain(fromUrlStr:newUrl2)
        }
    }  // end func
    
    //判断url是否应该阻挡
    func isDropUrl(urlStr:String) -> Bool{
        var ret:Bool = false
        //先看用户设置的检查规则（白名单 还是 黑名单）
        let checkRule:String
        checkRule = "WHITE"
        let domain:String
        domain = getDomain(fromUrlStr:urlStr)
        if(checkRule.elementsEqual("WHITE")){
            //白名单规则过滤
            var inWhiteListFlag = false
            for whiteDomain in whiteList_G {
                if(domain.contains(whiteDomain)){
                    inWhiteListFlag = true
                    break
                }
            }
            if(!inWhiteListFlag){
                ret = true
            }
        }else{
            //黑名单规则过滤
        }
        return ret;
    }
    
    //从url中获取domain
    func getDomain(fromUrlStr:String) -> String{
        var ret:String = ""
        if(fromUrlStr.starts(with: "http")){
            let array = fromUrlStr.components(separatedBy: "://")
            if(array.count == 2){
                let tmpString = array[1]
                if(tmpString.contains("/")){
                    ret = String(tmpString[..<tmpString.index(of: "/")!])
                    let array2 = ret.components(separatedBy: ".")
                    if(array2.count>2){
                        let startIndex = ret.index(ret.index(of: ".")!,offsetBy: 1)
                        ret = String(ret[startIndex..<ret.endIndex])
                    }
                }else{
                    ret = tmpString
                }
            }
        }
        return ret
    }
    
    //MARK: NSTextFieldDelegate
    //按回车键或离开textfield即可发送内容
//    override func controlTextDidEndEditing(_ obj: Notification) {
//        let urlString = urlTextField.stringValue
//        viewReLoad(newUrl: urlString)
//
//    }
    
    //为textfield进行特殊按键（enter,delete,backspace,tab,esc）响应处理
    //NSTextField 的代理类 NSTextFieldDelegate 继承自 NSControlTextEditingDelegate 类，后者定义了特殊按键的响应协议方法，实现下面协议方法即可拦截特殊按键事件来进行处理。
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print("Selector method inside text field: \(commandSelector)")
        if commandSelector == #selector(insertNewline(_:)) {
            let modifierFlags = NSApplication.shared.currentEvent?.modifierFlags
            if ( (modifierFlags != nil) && ((modifierFlags?.rawValue)! & NSEvent.ModifierFlags.shift.rawValue) != 0)
            {
                print("Shift-Enter detected.")
            } else {
                print("Enter detected.")
                let urlString = urlTextField.stringValue
                viewReLoad(newUrl: urlString)
            }
            // https://developer.apple.com/library/prerelease/content/qa/qa1454/_index.html
            // If we want to insert new line instead of default action, which will complete editing.
            //            textView.insertNewlineIgnoringFieldEditor(self)
            
            return true
        }
        // * return true: Ignore system default behavior.
        // * return false: Let system to execute its default implementation for the selector.
        return false
    }
    
    //GoButton Action
    @IBAction func goToUrl(_ sender: NSButton) {
        if(sender.title == "Go!"){
            let urlString = urlTextField.stringValue
            viewReLoad(newUrl: urlString)
        }else{
            if(myWebView.isLoading){
                myWebView.stopLoading()
            }
            progressIndicator.stopAnimation(nil)
            GoButton.title = "Go!"
        }
    }
    
    //缩放
    @IBAction func sliderAction(_ sender: NSSlider) {
        let scaleValue = sender.floatValue
        myWebView.setMagnification(CGFloat(scaleValue), centeredAt: CGPoint(x:0.0,y:0.0))
    }
    
    //显示Modal Window
    func showModalWindow(domain:String) {
        
        // 1
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let modalWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ModalWindowController")) as! NSWindowController
        
        if let modalWindow = modalWindowController.window {
            
            // 2
            let modalWindowViewController = modalWindow.contentViewController as! ModalWindowViewController
            modalWindowViewController.setPromptTF(rejectDomain: domain)
            // 3
            NSApplication.shared.runModal(for: modalWindow)
            //以下方式创建的modal window 允许主程序响应快捷键和系统菜单。但此方式下，执行到第4步会导致modal
            //window 被直接关闭。此方式下，不能有以下modalWindow.close() 的代码，要通过监听窗口关闭事件关闭
            //窗口并结束模态（）
//            NSApplication.shared.beginModalSession(for: modalWindow)
            // 4 Close the window once the modal state is over. Note that this statement does not execute till the modal state is completed.
            modalWindow.close()
        }
    }
    
    var topLevelArray: NSArray?
    //域名被阻挡的警告panel
    lazy var myPanel: MyPanel? = {
        var panel: MyPanel?
        let nib  = NSNib.init(nibNamed: NSNib.Name(rawValue: "MyPanel"), bundle: Bundle.main)
        if let success =  nib?.instantiate(withOwner: self, topLevelObjects: &topLevelArray) {
            if success {
                for obj in self.topLevelArray! {
                    if obj is MyPanel {
                        panel = obj as? MyPanel
                        break
                    }
                }
            }
        }
        return panel
    }()
    //添加白名单的panel
    lazy var addWLPanel: AddWLPanel? = {
        var panel: AddWLPanel?
        let nib  = NSNib.init(nibNamed: NSNib.Name(rawValue: "MyPanel"), bundle: Bundle.main)
        if let success =  nib?.instantiate(withOwner: self, topLevelObjects: &topLevelArray) {
            if success {
                for obj in self.topLevelArray! {
                    if obj is AddWLPanel {
                        panel = obj as? AddWLPanel
                        break
                    }
                }
            }
        }
        return panel
    }()
    
    //通用警告的panel
    lazy var warnPanel: WarnPanel? = {
        var panel: WarnPanel?
        let nib  = NSNib.init(nibNamed: NSNib.Name(rawValue: "MyPanel"), bundle: Bundle.main)
        if let success =  nib?.instantiate(withOwner: self, topLevelObjects: &topLevelArray) {
            if success {
                for obj in self.topLevelArray! {
                    if obj is WarnPanel {
                        panel = obj as? WarnPanel
                        break
                    }
                }
            }
        }
        return panel
    }()
    
    //显示警告Panel
    func showModalPanel(domain:String,warnString:String) {
        self.myPanel?.parent = self.view.window
        self.myPanel?.warnLabel.stringValue = warnString
        self.view.window?.beginSheet(self.myPanel!, completionHandler: {  returnCode in
            if returnCode.rawValue == kOkCode {
                //print("returnCode \(returnCode)")
                let infoLabel = "将域[" + domain + "]加入我的白名单"
                self.showAddWLPanel(domain:domain,infoString:infoLabel)
            }
        })
    }
    
    //显示通用警告Panel
    func showWarnPanel(warnString:String) {
        self.warnPanel?.parent = self.view.window
        self.warnPanel?.infoLabel.stringValue = warnString
        self.view.window?.beginSheet(self.warnPanel!, completionHandler: {  returnCode in
            if returnCode.rawValue == kOkCode {
                //print("returnCode \(returnCode)")
            }
        })
    }
    
    //显示添加白名单Panel
    func showAddWLPanel(domain:String,infoString:String) {
        self.addWLPanel?.parent = self.view.window
        self.addWLPanel?.infoLabel.stringValue = infoString
        self.view.window?.beginSheet(self.addWLPanel!, completionHandler: {  returnCode in
            if returnCode.rawValue == kOkCode {
                var passwd = self.addWLPanel?.passwordTF.stringValue
                if(passwd == nil){
                    passwd = ""
                }
                let bwInfoService = BWInfoService()
                //调出indicator
                bwInfoService.addToWhiteList(userid: userId_G ,username: "ljy", token: token_G,domain: domain,password:passwd!).subscribe(onNext: { (generalResp: GeneralResp ) in
                    if(generalResp.errorCode == 0){
                        whiteList_G.append(domain)
                        self.showWarnPanel(warnString: "[" + domain + "]成功添加进白名单！请重新访问相应网站。")
                    }else{
                        self.showWarnPanel(warnString: generalResp.errorMsg!)
                    }
                    //隐藏indicator
                }).disposed(by: self.disposeBag)
                //print("returnCode \(returnCode)")
            }
            //重置，否则会被保留
            self.addWLPanel?.passwordTF.stringValue = ""
        })
    }
    
    
}  // end class

//extension WebViewController: NSControlTextEditingDelegate {
//
//    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSControlTextEditingDelegate_Protocol/#//apple_ref/occ/intfm/NSControlTextEditingDelegate/control:textView:doCommandBySelector:
//    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
//        print("Selector method inside text field: \(commandSelector)")
//        if commandSelector == #selector(insertNewline(_:)) {
//            let modifierFlags = NSApplication.shared.currentEvent?.modifierFlags
//            if ( (modifierFlags != nil) && ((modifierFlags?.rawValue)! & NSEvent.ModifierFlags.shift.rawValue) != 0)
//            {
//                print("Shift-Enter detected.")
//            } else {
//                print("Enter detected.")
//                let urlString = urlTextField.stringValue
//                viewReLoad(newUrl: urlString)
//            }
//            // https://developer.apple.com/library/prerelease/content/qa/qa1454/_index.html
//            // If we want to insert new line instead of default action, which will complete editing.
////            textView.insertNewlineIgnoringFieldEditor(self)
//
//            return true
//        }
//        // * return true: Ignore system default behavior.
//        // * return false: Let system to execute its default implementation for the selector.
//        return false
//    }
//}

