//
//  UserNetwork.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/12.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import Moya
enum UserApi {
    case login(userName: String, psd: String)
    case register(userName: String, psd: String)
    case userInfo
    case getSessionID
    case searchName(keyword: String)
    case addFriend(friendID: String, msg: String)
}

extension UserApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://123.206.136.17:8080")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/cyzm6/public/user/login"
        case .register:
            return "/cyzm6/public/user/register"
        case .userInfo:
            return "/suser/private/user/user/myinfo"
        case .getSessionID:
            return "/suser/sessionid"
        case .searchName:
            return "/suser/private/friend/searchname"
        case .addFriend:
            return "/suser/private/friend/add"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .userInfo:
            return .post
        case .getSessionID, .searchName, .addFriend:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .login, .register:
            guard let parameters = parameters else {return .requestPlain}
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .userInfo, .getSessionID:
            return .requestPlain
        case .searchName, .addFriend:
            guard let parameters = parameters else {return .requestPlain}
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    var parameters: [String : Any]? {
        switch self {
        case .login(let userName, let psd):
            let dic = ["email": userName, "pwd": psd]
            return dic
        case .register(let userName, let psd):
            let dic: [String : Any] = ["name": userName, "pwd": psd, "email": userName, "age": 1, "sex": 1]
            return dic
        case .userInfo, .getSessionID:
            return nil
        case .searchName(let keyword):
            let dic: [String: Any] = ["keyword": keyword, "page": 0, "size": 10]
            return dic
        case .addFriend(let friendID, let msg):
            let dic: [String : Any] = ["id": friendID, "msg": msg]
            return dic
        }
        
    }
    
}
extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
