//
//  WebViewModel.swift
//  WKWebView
//
//  Created by jason on 2017/10/10.
//  Copyright © 2017年 Marco Barnig. All rights reserved.
//

import Foundation
import RxMoya
import RxSwift
import ObjectMapper
import Moya

//struct TokenStruct2: Codable {
//    let token:String
//}

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

class WebViewModel {

    var MyWebProvider:MoyaProvider<APIManager>?
    var MyWebProvider2:MoyaProvider<APIManager>?
    
    func login(username: String,password: String) -> Observable<LoginResp> {
        MyWebProvider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        return MyWebProvider!.rx
            .request(.login(username,password)).asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type:LoginResp.self)
    }
    
    func getBWInfo(userid:Int, username: String,token: String) -> Observable<BWInfoResp> {
        let authPlugin = AccessTokenPlugin(tokenClosure: token)
        MyWebProvider2 = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),authPlugin])
        return MyWebProvider2!.rx
            .request(.getBWInfo(userid,username)).asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type:BWInfoResp.self)
    }
    
}

