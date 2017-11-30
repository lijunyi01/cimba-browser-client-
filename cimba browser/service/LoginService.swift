//
//  LoginService.swift
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

class LoginService {
    
    var MyWebProvider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    
    func login(username: String,password: String) -> Observable<LoginResp> {
        return MyWebProvider.rx
            .request(.login(username,password)).asObservable()
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapObject(type:LoginResp.self)
    }
    
}
