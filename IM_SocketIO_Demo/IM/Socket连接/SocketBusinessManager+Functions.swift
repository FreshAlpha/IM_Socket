//
//  SocketBusinessManager+Functions.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/16.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON
struct SocketFunction {
    public typealias SocketBusinessCallback = ([Any], SocketBusinessManager) -> ()
    let emitEvent: String
    let responseEvent: String
    let handler: SocketBusinessCallback
}
extension SocketBusinessManager {
    static let friendOnline: SocketFunction = SocketFunction(emitEvent: "", responseEvent: "sfonline") { (data, mgr) in
        print("好友上线消息")
    }
    static let friendOffline: SocketFunction = SocketFunction(emitEvent: "", responseEvent: "sfoffline") { (data, mgr) in
        print("好友下线消息")
    }
}
struct MessageSource {
    let identifier: String
    let from: String
    let to: String
    init(with json: JSON) {
        identifier = json["_id"].stringValue
        from = json["myid"].stringValue
        to = json["frid"].stringValue
    }
}
