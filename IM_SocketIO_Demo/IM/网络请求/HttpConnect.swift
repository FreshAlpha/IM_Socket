//
//  HttpConnect.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
class HttpConnect: NSObject {
    private let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    typealias ResponseHandler = (Bool) -> ()
    
    
}
//MARK: -登录注册
extension HttpConnect {
    //注册
    func register(username: String, pwd: String, email: String, age: Int, sex: Int, callBack: ResultHandler?) {
        provider.request(.register(userName: username, pwd: pwd, email: email, age: age, sex: sex)) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
                return
            }
            callBack?(.success)
            print("注册成功")

        }
    }
    //登录：以拿到sessionID和userID为登录成功标准
    func login(username: String, pwd: String, callBack: ResultHandler?) {
        provider.request(.login(userName: username, pwd: pwd)) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
                return
            }
            print("登录成功")
            //sessionID和userID两个请求都成功后再回调callBack: ResultHandler
            var userInfoError: SocketErrorType = .success
            let group = DispatchGroup()
            let userInfoRequest = DispatchQueue(label: "userInfo")
            group.enter()
            userInfoRequest.async(group: group, execute: {
                self.requestUserInfo(callBack: { (error) in
                    userInfoError = error
                    group.leave()
                })
            })
            //SessionID的请求
            var sessionIDError: SocketErrorType = .success
            let sessionIDRequest = DispatchQueue(label: "sessionID")
            group.enter()
            sessionIDRequest.async(group: group, execute: {
                self.getSessionID(callBack: { (error) in
                    sessionIDError = error
                    group.leave()
                })
            })
            //都请求并回调完成
            group.notify(queue: DispatchQueue.main) {
                switch (userInfoError, sessionIDError) {
                case (.success, .success):
                    callBack?(.success)
                case (.success, _):
                    callBack?(sessionIDError)
                case (_, .success):
                    callBack?(userInfoError)
                default:
                    callBack?(userInfoError)//传userInfo的error
                }
            }
        }
        
        
    }
    private func requestUserInfo(callBack: ResultHandler?) {
        provider.request(.userInfo, completion: { (result) in
            guard case .success(let response) = result else {return}
            guard let responseJSON = response.responseJSON?["data"] else {return}
            //            guard response.serverCodeType == .success else {return}
            print("拿到用户信息")
            print(responseJSON)
            self.handleUserInfo(responseJSON)
            callBack?(.success)
        })
    }
    private func getSessionID(callBack: ResultHandler?) {
        provider.request(.getSessionID) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(.noCode)
                return
            }
            print("拿到sessionID")
            UserInfo.shared().sessionID = response.responseJSON?["id"].string
            callBack?(.success)
        }
    }
    
    private func handleUserInfo(_ responseJSON: JSON) {
        UserInfo.shared().name = responseJSON["name"].stringValue
        UserInfo.shared().email = responseJSON["email"].stringValue
        UserInfo.shared().userId = responseJSON["id"].intValue
    }
 
    //
    func getFriendList(_ callBack: FriendsHandler?) {
        provider.request(.friendList) { (result) in
            guard case .success(let response) = result else {
                callBack?(nil, .noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(nil, response.socketResultCode)
                return
            }
            let friends: [FriendModel]? = (response.responseJSON?["data"].array?.reduce([FriendModel](), { (array, dicJson) -> [FriendModel] in
                var result = array
                let model = FriendModel(with: dicJson)
                result.append(model)
//                SocketBusinessManager.shared().fetchHistoryMsg(from: model.userID)
                return result
            }))
            callBack?(friends, .success)
        }
    }
}
//MARK: -添加好友
extension HttpConnect {
    //通过关键词查找好友
    func searchSomebody(by keyword: String, page currentPage: Int, pageSize size: Int, _ callBack: FriendsHandler?) {
        provider.request(.searchName(keyword: keyword, page: currentPage, pagesize: size)) { (result) in
            guard case .success(let response) = result else {
                callBack?(nil, .noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(nil, response.socketResultCode)
                return
            }
            let searchResult: [FriendModel]? = (response.responseJSON?["data"].array?.reduce([FriendModel](), { (array, dicJson) -> [FriendModel] in
                var result = array
                let model = FriendModel(bysearch: dicJson)
                result.append(model)
                return result
            }))
            callBack?(searchResult, .success)
        }
    }
    
    //通过ID添加好友
    func requestAddingFriend(by friendID: Int, message msg: String, _ callBack: ResultHandler?) {
        provider.request(.addFriend(friendID: friendID, msg: msg)) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
                print("添加朋友申请失败")
                return
            }
            callBack?(.success)
            print("添加好友申请成功")
        }
    }
    //同意加好友
    func approveMakingFriend(by friendID: Int, isArrpoved approved: Bool, callBack: ResultHandler?) {
        provider.request(.approveFriend(friendID: friendID, approved: approved)) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
                print("同意好友友申请失败")
                return
            }
            callBack?(.success)
        }
    }
    
}
//MARK: -群组
extension HttpConnect {
    //创建群组
    func createGroup(with groupName: String, and remark: String = "", callBack: GroupHandler?) {
        provider.request(.createGroup(name: groupName, remark: remark)) { (result) in
            guard case .success(let response) = result else {
                callBack?(nil, .noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(nil, response.socketResultCode)
                print("创建群组失败")
                return
            }
            let group = GroupModel(with: response.responseJSON)
            print("创建群组成功")
            callBack?(group, .success)
        }
    }
    //搜索群组（通过群名称）
    func searchGroup(with groupName: String, page currentPage: Int, pagesize size: Int, callBack: SearchGroupHandler?) {
        provider.request(.searchGroup(keyword: groupName, page: currentPage, pagesize: size)) { (result) in
            guard case .success(let response) = result else {
                callBack?(nil, .noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(nil, response.socketResultCode)
                print("创建群组失败")
                return
            }
            let searchResult: [GroupModel]? = (response.responseJSON?["data"].array?.reduce([GroupModel](), { (array, dicJson) -> [GroupModel] in
                var result = array
                let model = GroupModel(with: response.responseJSON)
                if let model = model {
                    result.append(model)
                }
                return result
            }))
            print("创建群组成功")
            callBack?(searchResult, .success)
        }
    }
    //申请加入群组
    func joinGroup(with ownerID: String, groupID gid: String, message msg: String, callBack: ResultHandler?) {
        provider.request(.joinGroup(ownerID: ownerID, groupID: gid, msg: msg)) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
                print("加入群组申请失败")
                return
            }
            print("加入群组申请成功")
            callBack?(.success)
        }
    }
    //同意加入群组
}
