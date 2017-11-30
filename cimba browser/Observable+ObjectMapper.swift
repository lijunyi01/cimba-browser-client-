//
//  Observable+ObjectMapper.swift
//  WKWebView
//
//  Created by jason on 2017/11/3.
//  Copyright © 2017年 Marco Barnig. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

//extension Response {
//    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
//        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
//            throw MoyaError.jsonMapping(self)
//        }
//        return object
//    }
//
//    public func mapArray<T: BaseMappable>(_ type: T.Type) throws -> [T] {
//        let json = JSON(data: self.data)
//        let jsonArray = json["data"]["data"]
//
//        guard let array = jsonArray.arrayObject as? [[String: Any]],
//            let objects = Mapper<T>().mapArray(JSONArray: array) else {
//                throw MoyaError.jsonMapping(self)
//        }
//        return objects
//    }
//}

//数据类建立好之后，我们还需要为 RxSwift 中的 Observable 写一个简单的扩展方法 mapObject，利用我们写好的 各“Model” 类，一步就把 JSON 数据映射成一个个 "model"对象。
extension Observable {
    
    //mapObject 方法处理单个对象
    public func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    //mapArray 方法处理对象数组
    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            guard let array = response as? [Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }
            
            return Mapper<T>().mapArray(JSONArray: dicts)
        }
    }
    
}

//自定义了简单的 Error，继承了 Swift 的 Error 类
enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error { }
