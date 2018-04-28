//
//  SocketChatManager+ReceiveFunctions.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import SwiftyJSON
struct SocketReceiveFuntion<T> {
    public typealias SocketReceiveCallback = ([Any], T) -> ()
    let cmd: String
    let handler: SocketReceiveCallback
}
extension SocketChatManager {
    //离线消息
    static let offlineMsg = SocketReceiveFuntion<SocketChatManager>(cmd: "saoff") { (data, mgr) in
        print("离线消息")
        let message = SocketMessageModel(isSend: false, eventName: .offlineMsg)
        /*
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.receiveData(message)
        })
 */
    }
    //历史消息
    static let historyMsg = SocketReceiveFuntion<SocketChatManager>(cmd: "shistory") { (data, mgr) in
        print("历史消息")
        guard let responseJson: JSON = JSON(data).array?.first else {return}
        guard let sourceArray: [JSON] = responseJson["fid"].array, sourceArray.count >= 2 else {return}
        guard let responseArray: [JSON] = responseJson["data"].array, responseArray.count > 0 else {return}
        /*
        objc_sync_enter(self)
        mgr.chatMessages += friendsMessage
        objc_sync_exit(self)
        mgr.delegates.forEach({ (delegator) in
            friendsMessage.forEach({ (msg) in
                delegator.delegate?.receiveHistoryChatMessage(msg)
            })
        })
 */
        
    }
    //单聊互发消息
    static let reveiveMessage = SocketReceiveFuntion<SocketChatManager>(cmd: "sfmsg") { (data, mgr) in
        print("其他用户发到自己的信息,或者上次发送的消息的回执")
        guard let responseJson = JSON(data).array?.first else {return}
        let socketMessage = SocketMessage(byFriendServer: responseJson)
        mgr.getConversation(with: socketMessage.conversationID).addMessage(socketMessage)
        mgr.weakDelegates.forEach({ (delegator) in
            delegator.delegate?.receiveCommonChatMessage(socketMessage.copy() as! SocketMessage)
        })

    }
}

extension Array where Element == SocketConversationModel {
    
}
