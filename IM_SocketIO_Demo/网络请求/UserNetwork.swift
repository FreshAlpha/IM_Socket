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
    case approveFriend(friendID: String)
    case friendList
    case createGroup(name: String, remark: String)
    case searchGroup(keyword: String)
    case joinGroup(groupID: String, msg: String)
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
        case .approveFriend:
            return "/suser/private/friend/addcheck"
        case .friendList:
            return "/suser/private/friend/getlist"
        case .createGroup:
            return "/suser/private/group/creategroup"
        case .searchGroup:
            return "/suser/private/group/searchgroupbyname"
        case .joinGroup:
            return "/suser/private/group/applygroup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .userInfo, .approveFriend, .friendList, .createGroup, .searchGroup, .joinGroup:
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
        case .login, .register, .approveFriend, .createGroup, .searchGroup, .joinGroup:
            guard let parameters = parameters else {return .requestPlain}
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .userInfo, .getSessionID, .friendList:
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
        let dic: [String: Any]?
        switch self {
        case .login(let userName, let psd):
            dic = ["email": userName, "pwd": psd]
        case .register(let userName, let psd):
            dic = ["name": userName, "pwd": psd, "email": userName, "age": 1, "sex": 1]
        case .userInfo, .getSessionID, .friendList:
            dic = nil
        case .searchName(let keyword):
            dic = ["keyword": keyword, "page": 0, "size": 10]
        case .addFriend(let friendID, let msg):
            dic = ["id": friendID, "msg": msg]
        case .approveFriend(let friendID):
            dic = ["fid": friendID]
        case .createGroup(let name, let remark):
            dic = ["name": name, "remark": remark]
        case .searchGroup(let keyword):
            dic = ["keyword": keyword, "page": 0, "size": 10]
        case .joinGroup(let groupID, let msg):
            dic = ["id": UserInfo.shared().userId, "gid": groupID, "msg": msg]
        }
        return dic
    }
    
}
extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
