//
//  LoginResp.swift
//  WKWebView
//
//  Created by jason on 2017/11/4.
//  Copyright © 2017年 Marco Barnig. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResp: Mappable {
    var token: String?
    var userid: Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token    <- map["token"]
        userid  <- map["userId"]
    }
}
