//
//  WhiteList.swift
//  WKWebView
//
//  Created by jason on 2017/11/6.
//  Copyright © 2017年 Marco Barnig. All rights reserved.
//

import Foundation
import ObjectMapper

class BWInfoResp: Mappable {
    var bwflag: Int?
    var whitelist: Array<String>?
    var blacklist: Array<String>?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        bwflag    <- map["bwFlag"]
        whitelist    <- map["whiteList"]
        blacklist    <- map["blackList"]
    }
}
