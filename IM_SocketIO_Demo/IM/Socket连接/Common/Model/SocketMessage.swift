//
//  SocketMessage.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/27.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SwiftyJSON
@objc enum SocketMessageDirection: NSInteger {
    case send = 0
    case receive = 1
}

@objc enum ChatType: NSInteger {
    case chat = 0
    case group = 1
}

@objc enum MessageStatus: NSInteger {
    case sending = 0
    case succeed = 1
    case failed = 2
}


class SocketMessage: NSObject {
    var conversationID: String = ""
    var messageID: String = ""
    var direction: SocketMessageDirection {
        if from == UserInfo.shared().userId {
           return .send
        } else {
            return .receive
        }
    }
    var from: String = ""
    var to: String = ""
    var timestamp: Double = 0
    var chatType: ChatType = .chat
    var status: MessageStatus = .succeed
    var body: SocketMessageBody?
    convenience init(byFriendServer serverJson: JSON) {
        self.init()
        from = serverJson["from"].stringValue
        to = serverJson["to"].stringValue
        conversationID = from == UserInfo.shared().userId ? to : from
        messageID = serverJson["id"].stringValue
        timestamp = serverJson["sendDate"].doubleValue
        chatType = .chat
        status = .succeed
        body = SocketTextBody(with: serverJson["msg"].stringValue)
    }
   
    convenience init(byGroupServer serverJson: JSON) {
        self.init()
        from = serverJson["from"].stringValue
        to = serverJson["to"].stringValue
        conversationID = from == UserInfo.shared().userId ? to : from
        messageID = serverJson["id"].stringValue
        timestamp = serverJson["sendDate"].doubleValue
        chatType = .chat
        status = .succeed
        body = SocketTextBody(with: serverJson["msg"].stringValue)
    }
}
extension SocketMessage: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SocketMessage()
        copy.from = self.from
        copy.to = self.to
        copy.conversationID = self.conversationID
        copy.messageID = self.messageID
        copy.timestamp = self.timestamp
        copy.chatType = self.chatType
        copy.status = self.status
        copy.body = self.body
        return copy
        
    }
}
