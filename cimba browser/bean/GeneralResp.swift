//
//  GeneralResp.swift
//  cimba browser
//
//  Created by jason on 2017/12/28.
//  Copyright © 2017年 jason. All rights reserved.
//

import Foundation
import ObjectMapper

class GeneralResp: Mappable {
    
    var errorCode: Int?
    var errorMsg: String?
    var retContent: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        errorCode    <- map["errorCode"]
        errorMsg  <- map["errorMsg"]
        retContent  <- map["retContent"]
    }
}
