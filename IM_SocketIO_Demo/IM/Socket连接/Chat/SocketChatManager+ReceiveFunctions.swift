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
        let sourceIDs: [MessageSource] = (sourceArray.reduce([MessageSource](), { (array, dicJson) -> [MessageSource] in
            var result = array
            let model = MessageSource(with: dicJson)
            result.append(model)
            return result
        }))
        let friendsMessage: [MessageModel] = (responseArray.reduce([MessageModel](), { (array, dicJson) -> [MessageModel] in
            var result = array
            var from = ""
            var to = ""
            for source in sourceIDs {
                if  dicJson["fid"].stringValue == source.identifier {
                    from = source.from
                    to = source.to
                }
            }
            let model = MessageModel(from: from, to: to, identifier: dicJson["_id"].stringValue, msg: dicJson["msg"].stringValue)
            result.append(model)
            return result
        }))
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
    //互发消息
    static let reveiveMessage = SocketReceiveFuntion<SocketChatManager>(cmd: "sfmsg") { (data, mgr) in
        print("其他用户发到自己的信息,或者上次发送的消息的回执")
        guard let responseJson = JSON(data).array?.first else {return}
        let model = MessageModel(with: JSON(responseJson))
        /*
        objc_sync_enter(self)
        mgr.chatMessages.append(model)
        objc_sync_exit(self)
        mgr.delegates.forEach({ (delegator) in
            delegator.delegate?.receiveCommentChatMessage(model)
        })
 */
    }
}
