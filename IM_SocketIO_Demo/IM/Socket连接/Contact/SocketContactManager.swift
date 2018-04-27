//
//  SocketConnectManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/25.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
class WeakContactDelegate: NSObject {
    weak var delegate: SocketContactManagerDelegate?
    required init(delegate: SocketContactManagerDelegate?) {
        self.delegate = delegate
    }
}
class SocketContactManager: NSObject {
    private let httpConnect = HttpConnect()
    fileprivate let friendHandlerQueue = DispatchQueue(label: "bl.im.friendHandlerQueue")
    //PUBLIC
    var friendInvitations = [String : ContactModel]()
    var weakDelegates = [WeakContactDelegate]()
    func addDelegate(_ delegate: SocketContactManagerDelegate) {
        self.weakDelegates.append(WeakContactDelegate(delegate: delegate))
    }
}
//HTTP
extension SocketContactManager {
    //拿到好友列表
    func fetchFriends(completion aCompletion: FriendsHandler?) {
        httpConnect.getFriendList { (friends, error) in
            aCompletion?(friends, error)
        }
    }
    //搜索某人得到的结果列表
    func searchSomebody(by keyword: String, completion aCompletion: FriendsHandler?) {
        httpConnect.searchSomebody(by: keyword) { (accounts, error) in
            aCompletion?(accounts, error)
        }
    }
    //请求添加好友
    func requestForAddingFriend(by friendID: String, messsage msg: String, completion aCompletion: ContactHandler?) {
        httpConnect.requestAddingFriend(by: friendID, message: msg) { (error) in
            guard case .success = error else {
                aCompletion?(nil, error)
                return
            }
            let contact = ContactModel(byHttp: friendID, contact: .selfRequestFriend, message: msg)
            self.addInvitation(contact)
            aCompletion?(contact.copy() as? ContactModel, error)
        }
    }
    //我同意好友申请
    func approveMakingFriend(by friendID: String, completion aCompletion: ResultHandler?) {
        httpConnect.approveMakingFriend(by: friendID) { (error) in
            guard case .success = error else {
                aCompletion?(error)
                return
            }
            let contact: ContactModel
            if let invitation = self.friendInvitations[friendID] {
                invitation.contactType = .approveFriend
                contact = invitation
            } else {
                contact = ContactModel(byHttp: friendID, contact: .approveFriend, message: nil)
                self.addInvitation(contact)
            }
            aCompletion?(error)
        }
    }
}
//Socket
extension SocketContactManager {
    
}
extension SocketContactManager {
    func getInvitations() -> [ContactModel] {
        let array = Array(self.friendInvitations.values)
        //TODO:按时间排序
        return array.map{$0.copy() as! ContactModel}
    }
    func addInvitation(_ invitation: ContactModel) {
        friendHandlerQueue.sync {
            self.friendInvitations[invitation.from] = invitation
        }
    }
}
