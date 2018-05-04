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
    var conversationID: Int = -1
    var messageID: String = ""
    var direction: SocketMessageDirection {
        if from == UserInfo.shared().userId {
           return .send
        } else {
            return .receive
        }
    }
    var from: Int = -1
    var to: Int = -1
    var timestamp: Double = 0
    var chatType: ChatType = .chat
    var status: MessageStatus = .succeed
    var body: SocketMessageBody?
}
//MARK: -收到消息处理
extension SocketMessage {
    convenience init(byFriendServer serverJson: JSON) {
        self.init()
        from = serverJson["from_uid"].intValue
        to = serverJson["to_uid"].intValue
        conversationID = from == UserInfo.shared().userId ? to : from
        messageID = serverJson["id"].stringValue
        timestamp = serverJson["datetime"].doubleValue
        chatType = .chat
        status = .succeed
        body = createMessageBody(with: serverJson)
    }
    
    convenience init(byGroupServer serverJson: JSON) {
        self.init()
        from = serverJson["from_uid"].intValue
        to = serverJson["to_gid"].intValue
        conversationID = from == UserInfo.shared().userId ? to : from
        messageID = serverJson["id"].stringValue
        timestamp = serverJson["datetime"].doubleValue
        chatType = .group
        status = .succeed
        body = self.createMessageBody(with: serverJson)
    }
    
    private func createMessageBody(with json: JSON) -> SocketMessageBody? {
        guard let msgType = MessageBodyType(rawValue: json["mtype"].intValue) else {
            return nil
        }
        switch msgType {
        case .text:
            return SocketTextBody(with: json["msg"].stringValue)
        default:
            //TODO: -其他消息格式待补充
            return nil
        }
    }
}

//MARK: -用于发消息
extension SocketMessage {
    //文本消息初始化(用于发消息)
    public convenience init(from: Int, to: Int, text msg: String) {
        self.init()
        self.from = from
        self.to = to
        self.messageID = ""
        self.body = SocketTextBody(with: msg)
    }
    //用于发消息
    public func mapToDic() -> [String: Any] {
        var dic: [String: Any] = ["id": self.messageID]
        switch self.chatType {
        case .chat:
            dic["to_uid"] = self.to
        case .group:
            dic["to_gid"] = self.to
        }
        if let bodyDic = self.body?.mapToDic() {
            dic.merge(bodyDic) { $1 }
        }
        return dic
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
