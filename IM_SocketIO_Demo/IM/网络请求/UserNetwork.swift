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
    case login(userName: String, pwd: String)
    case register(userName: String, pwd: String, email: String, age: Int, sex: Int)
    case userInfo
    case getSessionID
    case searchName(keyword: String, page: Int, pagesize: Int)
    case addFriend(friendID: Int, msg: String)
    case approveFriend(friendID: Int, approved: Bool)
    case friendList
    case createGroup(name: String, remark: String)
    case searchGroup(keyword: String, page: Int, pagesize: Int)
    case joinGroup(ownerID: String, groupID: String, msg: String)
    case approveJoinGroup(messageID: String)
}

extension UserApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://123.206.136.17:8111")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/pub/user/login"
        case .register:
            return "/pub/user/regist"
        case .userInfo:
            return "/user/myinfo"
        case .getSessionID:
            return "/user/sessionid"
        case .searchName:
            return "/user/searchname"
        case .addFriend:
            return "/friend/add"
        case .approveFriend:
            return "/friend/addcheck"
        case .friendList:
            return "/friend/getlist"
        case .createGroup:
            return "/group/creategroup"
        case .searchGroup:
            return "/group/searchgroupbyname"
        case .joinGroup:
            return "/group/applyjoingroup"
        case .approveJoinGroup:
            return "/group/applyjoingroupcheck"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register,.addFriend, .approveFriend, .createGroup, .searchGroup, .joinGroup, .approveJoinGroup:
            return .post
        case .userInfo, .getSessionID, .searchName, .friendList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case .register, .login, .approveFriend, .createGroup, .searchGroup, .joinGroup, .approveJoinGroup:
            guard let parameters = parameters else {return .requestPlain}
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .userInfo, .getSessionID, .friendList:
            return .requestPlain
        case .searchName, .addFriend:
            guard let parameters = parameters else {return .requestPlain}
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
//            return ["Content-Type": "application/json"]
     
    }
    var parameters: [String : Any]? {
        let dic: [String: Any]?
        switch self {
        case .login(let userName, let psd):
            dic = ["email": userName, "pwd": psd]
        case .register(let userName, let pwd, let email, let age, let sex):
            dic = ["name": userName, "pwd": pwd, "email": email, "age": age, "sex": sex]
        case .userInfo, .getSessionID, .friendList:
            dic = nil
        case .searchName(let keyword, let page, let pagesize):
            dic = ["keyword": keyword, "page": page, "size": pagesize]
        case .addFriend(let friendID, let msg):
            dic = ["id": friendID, "msg": msg]
        case .approveFriend(let friendID, let approved):
            dic = ["fid": friendID, "confirm": approved ? 1 : 0]
        case .createGroup(let name, let remark):
            dic = ["name": name, "remark": remark]
        case .searchGroup(let keyword, let page, let pagesize):
            dic = ["gname": keyword, "page": page, "size": pagesize]
        case .joinGroup(let ownerID, let groupID, let msg):
            dic = ["gownid": ownerID, "gid": groupID, "msg": msg]
        case .approveJoinGroup(let messageID):
            dic = ["msgid": messageID]
        }
        return dic
    }
    
}
extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
