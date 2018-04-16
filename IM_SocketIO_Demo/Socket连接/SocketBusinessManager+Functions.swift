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
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.reveiveData(data)
        })
    }
    //离线消息
    static let offlineMsg: SocketFunction = SocketFunction(emitEvent: "caoff", responseEvent: "saoff") { (data, mgr) in
        print("离线消息")
        print(data)
    }
    //历史消息
    static let historyMsg: SocketFunction = SocketFunction(emitEvent: "chistory", responseEvent: "shistory") { (data, mgr) in
        print("历史消息")
        print(data)
    }
}
