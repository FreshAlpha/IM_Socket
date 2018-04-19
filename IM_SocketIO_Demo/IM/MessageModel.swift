//
//  MessageModel.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/18.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SwiftyJSON
class MessageModel: NSObject {
    let from: String
    let to: String
    let identifier: String
    let msg: String
    let isSender: Bool //是否是发送的消息
    required init(with dicJson: JSON) {
        from = dicJson["from"].stringValue
        to = dicJson["to"].stringValue
        identifier = dicJson["id"].stringValue
        msg = dicJson["msg"].stringValue
        isSender = from == UserInfo.shared().userId
    }
    required init(from: String, to: String, identifier: String, msg: String) {
        self.from = from
        self.to = to
        self.identifier = identifier
        self.msg = msg
        isSender = from == UserInfo.shared().userId
        
    }
    func mapDic() -> [String: Any] {
        return ["id": 0, "from": from, "to": to, "sendDate": 0, "msg": msg]
    }
}