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

class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSTextFieldDelegate{
    
    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var myWebView: WKWebView!
    
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
        
        //add by ljy
        if(isDropUrl(urlStr:urlString)){
            let myURL = URL(string: "https://cn.bing.com")
            let myRequest = URLRequest(url: myURL!)
            myWebView.load(myRequest)
        }
        
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
        
        view.addSubview(myWebView)
        Swift.print("urlString_G:"+urlString_G)
        let myURL = URL(string: urlString_G)
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
        winTitle_G = getDomain(fromUrlStr:urlString_G)
        Swift.print("set title:"+winTitle_G)
        
    }  // end func
    
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
//                    ret = tmpString.substring(to: tmpString.index(of: "/")!)  //swift3用
                    ret = String(tmpString[..<tmpString.index(of: "/")!])
                }else{
                    ret = tmpString
                }
            }
        }
        return ret
    }
    
    //MARK: UITextFieldDelegate
    //按回车键或离开textfield即可发送内容
    override func controlTextDidEndEditing(_ obj: Notification) {
        let urlString = urlTextField.stringValue
        viewReLoad(newUrl: urlString)
    
    }
    
}  // end class
