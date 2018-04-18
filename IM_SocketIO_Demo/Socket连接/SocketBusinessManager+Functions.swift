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
    //认证
    static let auth: SocketFunction = SocketFunction(emitEvent: "auth-c", responseEvent: "auth-s") { (data, mgr) in
        print("认证结果")
        
    }
    //离线消息
    static let offlineMsg: SocketFunction = SocketFunction(emitEvent: "caoff", responseEvent: "saoff") { (data, mgr) in
        print("离线消息")
        let message = SocketMessageModel(isSend: false, eventName: .offlineMsg)
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.receiveData(message)
        })
    }
    //历史消息
    static let historyMsg: SocketFunction = SocketFunction(emitEvent: "chistory", responseEvent: "shistory") { (data, mgr) in
        print("历史消息")
        mgr.delegates.forEach({ (delegator) in
            let message = SocketMessageModel(isSend: false, eventName: .historyMsg)
            delegator.delegate?.receiveData(message)
        })
    }
    //别人请求添加你为好友
    /*返回信息
     [{
     datetime = 1523955710490;
     from = 5ad559869ce7921feffdcc7a;
     msg = "hello\U00ef\U00bc\U008c\U00e6\U009d\U00a5\U00e8\U0087\U00aaiOS\U00e7\U009a\U0084\U00e6\U009c\U008b\U00e5\U008f\U008b";
     to = 5acdbddd15256f119f596567;
     type = addfriend;
     }]
     */
    static let friendInvitation: SocketFunction = SocketFunction(emitEvent: "", responseEvent: "addfriend") { (data, mgr) in
        print("别人请求添加你为好友")
        guard let responseJson = JSON(data).array?.first else {return}
        let model = SocketSystemMessage(fromID: responseJson["from"].stringValue, toID: responseJson["to"].stringValue, eventType: responseJson["type"].stringValue, msg: responseJson["msg"].stringValue)
        objc_sync_enter(self)
        var isNewInvation = true
        for msg in mgr.friendInvations {
            if msg.fromID == model.fromID {
                isNewInvation = false
                break
            }
        }
        guard isNewInvation else {return}
        mgr.friendInvations.append(model)
        objc_sync_exit(self)
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.receiveFriendInvation(model)
        })
    }
    //别人同意你的好友请求
    static let friendApproved: SocketFunction = SocketFunction(emitEvent: "", responseEvent: "addfriendcheckreply") { (data, mgr) in
        print("别人同意你的好友请求")
        guard let responseJson = JSON(data).array?.first else {return}
        let model = SocketSystemMessage(fromID: responseJson["from"].stringValue, toID: responseJson["to"].stringValue, eventType: responseJson["type"].stringValue, msg: responseJson["msg"].stringValue)
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.receiveFriendApprove(model)
        })
    }
    //互发消息
    static let sendMessage: SocketFunction = SocketFunction(emitEvent: "cfmsg", responseEvent: "sfmsg") { (data, mgr) in
        print("其他用户发到自己的信息,或者上次发送的消息的回执")
        guard let responseJson = JSON(data).array?.first else {return}
        let model = MessageModel(with: JSON(responseJson))
        objc_sync_enter(self)
        mgr.chatMessages.append(model)
        objc_sync_exit(self)
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.receiveCommentChatMessage(model)
        })
    }
}
