//
//  AppDelegate.swift
//  cimba browser
//
//  Created by jason on 2017/11/15.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa
import RxSwift
import RxRelay

// protocol
protocol feedBack {
    func output()
}

var whiteList_G = Array<String>()
var windowCount_G:BehaviorRelay<Int>  = BehaviorRelay(value:0)
var urlString_G: String = "https://cn.bing.com"
//var winTitle_G: String = ""
var userId_G: Int = 0
var token_G: String = ""

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let disposeBag = DisposeBag()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //清理HTTPCookieStorage.shared.cookies
//        let pastDateString = "2011-06-14 12:12:23"
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "zh_CN")
//        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMdd HHmmss")
//        let pastDate = dateFormatter.date(from: pastDateString)
//        HTTPCookieStorage.shared.removeCookies(since: pastDate!)
//        Swift.print("cookiestorage count:" + String(describing: HTTPCookieStorage.shared.cookies?.count))
        
        
        
        let loginService = LoginService()
        
        loginService.login(username: "ljy", password: "111111").subscribe(onNext: { (loginResp: LoginResp ) in
            //后台如果登录失败返回403，不会进入这里（filterSuccessfulStatusCodes()），进入这里一定登录成功
            let userId = loginResp.userid
            let token = loginResp.token
            //设置全局变量
            userId_G = userId!
            token_G = token!
            let bwInfoService = BWInfoService()
            bwInfoService.getBWInfo(userid: userId! ,username: "ljy", token: token!).subscribe(onNext: { (bwInfoResp: BWInfoResp ) in
                let bwFlag = bwInfoResp.bwflag
                if(bwFlag == 0){
                    for domain in bwInfoResp.whitelist!{
                        whiteList_G.append(domain)
                    }
                }
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //实现了这个代理方法，且返回true时，关闭最后一个/唯一一个窗口时，彻底关闭应用,而不只是退到后台
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

