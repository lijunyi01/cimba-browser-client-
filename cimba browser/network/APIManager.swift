//
//  APIManager.swift
//  WKWebView
//
//  Created by jason on 2017/10/10.
//  Copyright © 2017年 Marco Barnig. All rights reserved.
//

import Foundation
//import Cocoa
import Moya

// MARK: - Provider setup
//private func JSONResponseDataFormatter(_ data: Data) -> Data {
//    do {
//        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
//        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
//        return prettyData
//    } catch {
//        return data // fallback to original data if it can't be serialized.
//    }
//}

//let token = ""
//let authPlugin = AccessTokenPlugin(tokenClosure: token)
//
//let MyWebProvider = MoyaProvider<APIManager>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),authPlugin])

//let MyWebProvider = MoyaProvider<APIManager>(plugins: [authPlugin])

// MARK: - Provider support
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum APIManager {
    case getBWInfo(Int,String)  //获取域名黑白名单信息
    case addToWhiteList(Int,String,String,String)  //将域名添加入白名单
    case login(String,String)  //登录验证
    case getNewsLatest//获取最新消息
//    case getStartImage// 启动界面图像获取
//    case getVersion(String)//软件版本查询
//    case getThemes//主题日报列表查看
//    case getThemeDetail(Int)//获取主题详情
//    case getNewsDetail(Int)//获取新闻详情
}

//TargetType 和 AccessTokenAuthorizable 是在Moya中定义的protocol
extension APIManager: TargetType, AccessTokenAuthorizable {
    
    // 实现 protocol AccessTokenAuthorizable 所需定义的闭包
    var authorizationType: AuthorizationType? {
        switch self {
        case .getBWInfo:
            return .bearer
        case .addToWhiteList:
            return .bearer
        case .getNewsLatest:
            return .basic
        default:
            return .bearer
        }
    }
    
    // 以下是实现 protocol TargetType 所需定义的闭包
    
    // [String : String] 相当于java中的 Map
    // The headers to be used in the request.
    var headers: [String : String]? {
        switch self {
        case .getBWInfo:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .addToWhiteList:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .login:
            return ["Content-Type": "application/json","test-header":"test-header-content"]
        default:
            return ["Content-Type": "application/json"]
        }
        
    }
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL.init(string: "https://usanode1.51his.com/")!
//        return URL.init(string: "http://localhost:8080/")!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        
        switch self {
            
        case .getBWInfo:
            return "cimba-auth/info/bwinfo"
            
        case .addToWhiteList:
            return "cimba-auth/info/addtowhitelist"
            
        case .login:
            return "cimba-auth/auth"
            
        case .getNewsLatest:
            return "4/news/latest"
            
        }
        
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .post
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
//        return "".data(using: String.Encoding.utf8)!
        return "{\"login\": \"ljy\", \"id\": 100}".data(using: String.Encoding.utf8)!
    }
    
    // The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case .getBWInfo(let userid,let username):
            return .requestParameters(parameters: ["userid": "\(userid)","username": "\(username)"], encoding: URLEncoding.default)
        case .addToWhiteList(let userid,let username,let domain,let password):
            return .requestParameters(parameters: ["userid": "\(userid)","username": "\(username)","domain": "\(domain)","passwd": "\(password)"], encoding: URLEncoding.default)
        case .login(let username,let password):
            return.requestData("{\"username\": \"\(username)\",\"password\": \"\(password)\"}".data(using: String.Encoding.utf8)!)
        default:
            return .requestPlain
        }
        
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return false
    }
    
}

