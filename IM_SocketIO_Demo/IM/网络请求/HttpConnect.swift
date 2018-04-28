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
    func register(username: String, pwd: String, callBack: ResultHandler?) {
        provider.request(.register(userName: username, psd: pwd)) { (result) in
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
    //登录：以拿到sessionID为登录成功标准
    func login(username: String, pwd: String, callBack: ResultHandler?) {
        provider.request(.login(userName: username, psd: pwd)) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
                return
            }
            print("登录成功")
            self.requestUserInfo()
            self.getSessionID({ (error) in
                callBack?(error)
            })
        }
    }
    private func requestUserInfo() {
        provider.request(.userInfo, completion: { (result) in
            guard case .success(let response) = result else {return}
            guard let responseJSON = response.responseJSON else {return}
            //            guard response.serverCodeType == .success else {return}
            print("拿到用户信息")
            print(responseJSON)
            self.handleUserInfo(responseJSON)
        })
    }
    private func getSessionID(_ callBack: ResultHandler?) {
        provider.request(.getSessionID) { (result) in
            guard case .success(let response) = result else {
                callBack?(.noCode)
                return
            }
            guard response.socketResultCode == .success else {
                callBack?(response.socketResultCode)
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
        UserInfo.shared().userId = responseJSON["_id"].stringValue
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
    func searchSomebody(by keyword: String, _ callBack: FriendsHandler?) {
        provider.request(.searchName(keyword: keyword)) { (result) in
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
    func requestAddingFriend(by friendID: String, message msg: String, _ callBack: ResultHandler?) {
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
    func approveMakingFriend(by friendID: String, callBack: ResultHandler?) {
        provider.request(.approveFriend(friendID: friendID)) { (result) in
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
extension HttpConnect {
    func createGroup(with groupName: String, and remark: String = "") {
        provider.request(.createGroup(name: groupName, remark: remark)) { (result) in
            guard case .success(let response) = result, response.socketResultCode == .success else {
                print("创建群组失败")
                return
            }
            print("创建群组成功")
        }
    }
}
