//
//  IMManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/18.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
/*
 将http请求涉及的业务放到此类中，包括处理socket的一些信息（SocketBusinessManager的信息）
 */
class IMManager: NSObject {
    private let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    private let userInfo = UserInfo.shared()
    static let singleTon = IMManager()
    typealias responseHandler = (Bool) -> ()
    typealias friendsHandle = ([FriendModel]?) -> ()
    private override init() {
        super.init()
    }
    class func shared() -> IMManager {
        return singleTon
    }
    
}
//MARK: -登录注册
extension IMManager {
    //注册
    func register(username: String, pwd: String, callBack: responseHandler?) {
        provider.request(.register(userName: username, psd: pwd)) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {return}
            print("注册成功")
            print(response.responseJSON as Any)
        }
    }
    //登录：以拿到sessionID为登录成功标准
    func login(username: String, pwd: String, callBack: responseHandler?) {
        provider.request(.login(userName: username, psd: pwd)) { (result) in
            guard case .success(let response) = result else {
                callBack?(false)
                return
            }
            guard response.serverCodeType == .success else {
                callBack?(false)
                return
            }
            print("登录成功")
            print(response.responseJSON as Any)
            self.requestUserInfo()
            self.getSessionID({ (isSuccess) in
                callBack?(isSuccess)
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
    private func getSessionID(_ callBack: responseHandler?) {
        provider.request(.getSessionID) { (result) in
            guard case .success(let response) = result else {
                callBack?(false)
                return
            }
            guard response.serverCodeType == .success else {
                callBack?(false)
                return
            }
            print("拿到sessionID")
            print(response.responseJSON as Any)
            self.userInfo.sessionID = response.responseJSON?["id"].string
            SocketBusinessManager.shared().connect()
            callBack?(true)
        }
    }
    private func handleUserInfo(_ responseJSON: JSON) {
        userInfo.name = responseJSON["name"].stringValue
        userInfo.email = responseJSON["email"].stringValue
        userInfo.userId = responseJSON["_id"].stringValue
    }
    func getFriendList(_ callBack: friendsHandle?) {
        provider.request(.friendList) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {
                callBack?(nil)
                return
            }
            let friends: [FriendModel]? = (response.responseJSON?["data"].array?.reduce([FriendModel](), { (array, dicJson) -> [FriendModel] in
                var result = array
                let model = FriendModel(wiht: dicJson)
                result.append(model)
                return result
            }))
            callBack?(friends)
        }
    }
}
//MARK: -添加好友
extension IMManager {
    //通过关键词查找并添加好友
    func addSearchFriend(by keyword: String) {
        provider.request(.searchName(keyword: keyword)) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {
                print("查找失败")
                return
                
            }
            print("查找成功")
            if let friendID = response.responseJSON?.array?.first?.dictionary?["id"]?.string {
                self.addFriend(by: friendID)
            }
            
        }
    }
    //通过ID添加好友
    //原则上是private，由于addSearchFriend未调通，暂时公有
    func addFriend(by friendID: String) {
        provider.request(.addFriend(friendID: friendID, msg: "hello，来自iOS的朋友")) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {
                print("添加朋友申请失败")
                return
            }
            print("添加好友申请成功")
        }
    }
    //同意加好友
    func approveMakingFriend(by friendID: String, callBack: responseHandler?) {
        provider.request(.approveFriend(friendID: friendID)) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {return}
            //删除这条记录
            SocketBusinessManager.shared().delegateInvation(by: friendID)
            callBack?(true)
        }
    }
    
}
