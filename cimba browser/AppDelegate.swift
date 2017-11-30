//
//  AppDelegate.swift
//  cimba browser
//
//  Created by jason on 2017/11/15.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa
import RxSwift

// protocol
protocol feedBack {
    func output()
}

var whiteList_G = Array<String>()
var windowCount_G:Variable<Int>  = Variable(0)
var urlString_G: String = "https://cn.bing.com"
var winTitle_G: String = ""

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let disposeBag = DisposeBag()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let loginService = LoginService()
        
        loginService.login(username: "ljy", password: "111111").subscribe(onNext: { (loginResp: LoginResp ) in
            //后台如果登录失败返回403，不会进入这里（filterSuccessfulStatusCodes()），进入这里一定登录成功
            let userId = loginResp.userid
            let token = loginResp.token
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


}

