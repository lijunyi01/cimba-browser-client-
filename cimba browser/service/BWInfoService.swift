//
//  BWInfoService.swift
//  cimba browser
//
//  Created by jason on 2017/11/16.
//  Copyright © 2017年 jason. All rights reserved.
//

import Foundation

import RxMoya
import RxSwift
import ObjectMapper
import Moya

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

class BWInfoService {
    
    var MyWebProvider:MoyaProvider<APIManager>?
    
    func getBWInfo(userid:Int, username: String,token: String) -> Observable<BWInfoResp> {
        let authPlugin = AccessTokenPlugin(tokenClosure: token)
        MyWebProvider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),authPlugin])
        return MyWebProvider!.rx
            .request(.getBWInfo(userid,username)).asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type:BWInfoResp.self)
    }
    
    func addToWhiteList(userid:Int, username: String,token: String,domain:String,password:String) -> Observable<GeneralResp> {
        let authPlugin = AccessTokenPlugin(tokenClosure: token)
        MyWebProvider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),authPlugin])
        return MyWebProvider!.rx
            .request(.addToWhiteList(userid,username,domain,password)).asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type:GeneralResp.self)
    }
    
}
