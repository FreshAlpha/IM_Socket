//
//  SocketBusinessManager+Functions.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/16.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import SocketIO
struct SocketFunction {
    public typealias SocketBusinessCallback = ([Any], SocketBusinessManager) -> ()
    let emitEvent: String
    let responseEvent: String
    let handler: SocketBusinessCallback
}
extension SocketBusinessManager {
    //认证
    static let auth: SocketFunction = SocketFunction(emitEvent: "auth-c", responseEvent: "auth-s") { (data, mgr) in
        print("认证结果")
        
    }
    //离线消息
    static let offlineMsg: SocketFunction = SocketFunction(emitEvent: "caoff", responseEvent: "saoff") { (data, mgr) in
        print("离线消息")
        let message = SocketMessageModel(isSend: false, eventName: .offlineMsg)
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.reveiveData(message)
        })
    }
    //历史消息
    static let historyMsg: SocketFunction = SocketFunction(emitEvent: "chistory", responseEvent: "shistory") { (data, mgr) in
        print("历史消息")
        mgr.delegates.forEach({ (delegator) in
            let message = SocketMessageModel(isSend: false, eventName: .historyMsg)
            delegator.delegate?.reveiveData(message)
        })
    }
    static let friendInvitation: SocketFunction = SocketFunction(emitEvent: "", responseEvent: "addfriend") { (data, mgr) in
        print("别人请求添加你为好友")
        mgr.delegates.forEach({ (delegator) in
            
            delegator.delegate?.reveiveFriendInvation(data)
        })
    }
}
