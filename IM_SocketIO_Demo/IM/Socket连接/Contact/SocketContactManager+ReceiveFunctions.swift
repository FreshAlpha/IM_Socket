//
//  SocketContactManager+ReceiveFunctions.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/26.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import SwiftyJSON
extension SocketContactManager {
    static let friendInvitation = SocketReceiveFuntion<SocketContactManager>(cmd: "addfriend") { (data, mgr) in
        print("别人请求添加你为好友")
        guard let responseJson = JSON(data).array?.first else {return}
        let contact = ContactModel(bySocket: responseJson, contact: .friendInvitation)
        mgr.addInvitation(contact)
        mgr.weakDelegates.forEach({ (delegator) in
            delegator.delegate?.receiveFriendInvation(contact.copy() as! ContactModel)
        })
    }
    //别人同意你的好友请求
    static let friendApproved = SocketReceiveFuntion<SocketContactManager>(cmd: "addfriendcheckreply") { (data, mgr) in
        print("别人同意你的好友请求")
        guard let responseJson = JSON(data).array?.first else {return}
        let contact = ContactModel(bySocket: responseJson, contact: .friendAppriveMe)
        mgr.addInvitation(contact)
        mgr.weakDelegates.forEach({ (delegator) in
            delegator.delegate?.receiveFriendInvation(contact.copy() as! ContactModel)
        })
    }
}
