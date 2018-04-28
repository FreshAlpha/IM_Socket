//
//  SocketChatManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
class WeakChatDelegate: NSObject {
    weak var delegate: SocketChatManagerDelegate?
    required init(delegate: SocketChatManagerDelegate?) {
        self.delegate = delegate
    }
}
class SocketChatManager: NSObject {
    var weakDelegates = [WeakChatDelegate]() //外部调用方法的代理
    var conversations = [String: SocketConversationModel]() //会话的字典（包括单聊和群组）
    public func addDelegate(_ delegate: SocketChatManagerDelegate) {
        weakDelegates.append(WeakChatDelegate(delegate: delegate))
    }
    private func emit(_ emitType: SocketEmitType) {
        SocketIOManager.shared().socket.emit(emitType.cmd, with: emitType.parameters)
    }
    //发消息
    public func sendMessage(_ message: MessageModel) {
        let emitType = SocketEmitType.sendMessage(message)
        self.emit(emitType)
    }
    //发送服务端：获取离线消息
    public func fetchOfflineMsg() {
        let emitType = SocketEmitType.offlineMessage
        self.emit(emitType)
    }
    //发送服务端：获取历史好友消息
    func fetchHistoryMsg(from friendID: String, date timestamp: Double?) {
        DispatchQueue.once(token: friendID) {
            let emitType = SocketEmitType.friendHistoryMessage(friendID, timestamp)
            self.emit(emitType)
        }
    }
    //发送服务端：获取历史组消息
    func fetchGroupHistoryMsg(from groupID: String, date timestamp: Double?) {
        DispatchQueue.once(token: groupID) {
            let emitType = SocketEmitType.groupHistoryMessage(groupID, timestamp)
            self.emit(emitType)
        }
    }
}
extension SocketChatManager {
    func getConversation(with conversationID: String) -> SocketConversationModel {
        if  let conver: SocketConversationModel = self.conversations[conversationID] {
            return conver
        } else {
            let conversation = SocketConversationModel(conversationID)
            self.conversations[conversationID] = conversation
            return conversation
        }
    }
}
