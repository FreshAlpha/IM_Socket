//
//  SocketConversationModel.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/27.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class SocketConversationModel: NSObject {
    let conversationID: Int //单聊就是朋友的userID，群组就是groupID
    private var messages = [SocketMessage]()
    required init(_ conversationID: Int) {
        self.conversationID = conversationID
        super.init()
    }
    
    func addMessage(_ message: SocketMessage) {
        self.messages.append(message)
        //TODO: -存到硬盘中
    }
    func fetchMessageFrom(_ message: SocketMessage?, _ count: Int, completion aCompletion: MessagesHandler?) {
        //内存
        //硬盘
        //服务器待定
        //内存中的数据暂定一开始就从硬盘里面加载好了
        var targetArray = [SocketMessage]()
        var targetIdx: Int?
        objc_sync_enter(self)
        if let message = message {
            for (idx, msg) in self.messages.enumerated() {
                if message.messageID == msg.messageID {
                    targetIdx = idx
                    return
                }
            }
            for (idx, msg) in self.messages.enumerated() {
                if let targetIdx = targetIdx, targetIdx < idx,  idx <= targetIdx + count {
                    targetArray.append(msg.copy() as! SocketMessage)
                } else {
                    return
                }
            }
        } else {
            //取count条,
            for (idx, msg) in self.messages.enumerated() {
                if idx < count {
                    targetArray.append(msg.copy() as! SocketMessage)
                } else {
                  return
                }
            }
        }
        objc_sync_exit(self)
        aCompletion?(targetArray, targetArray.count == count ? .success : .noHistoryMessage)
    }
}
extension SocketConversationModel {
    //拿到当前会话的最新消息
    func getLeatestMessage() -> SocketMessage? {
        return self.messages.last?.copy() as? SocketMessage
    }
}

