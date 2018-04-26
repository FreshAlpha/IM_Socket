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
    //TODO：-疑问？这个接口的作用是为了调取所有历史消息吗？？？
    //TODO: web页调用的时机是缓存过下次再登录进入
    func fetchHistoryMsg(from friendID: String) {
        DispatchQueue.once(token: friendID) {
            let emitType = SocketEmitType.friendHistoryMessage(friendID)
            self.emit(emitType)
        }
    }
    //发送服务端：获取历史组消息
    func fetchGroupHistoryMsg(from groupID: String) {
        DispatchQueue.once(token: groupID) {
            let emitType = SocketEmitType.groupHistoryMessage(groupID)
            self.emit(emitType)
        }
    }
}

