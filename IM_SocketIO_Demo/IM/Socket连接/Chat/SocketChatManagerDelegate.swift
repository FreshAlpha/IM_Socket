//
//  SocketChatManagerProtocol.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
protocol SocketChatManagerDelegate: class {
    func receiveCommonChatMessage(_ message: SocketMessage)
    func receiveGroupChatMessage(_ message: SocketMessage)
    //当一条message收到后，会存到会话里面，在内存和DB里面会查找有没有这个会话，如果没有会调用此方法，告诉外部，增加一个新的会话
    func newConversation(_ conversation: SocketConversationModel)
}
extension SocketChatManagerDelegate {
    func receiveCommonChatMessage(_ message: SocketMessage) {
        
    }
    func newConversation(_ conversation: SocketConversationModel) {
        
    }
    func receiveGroupChatMessage(_ message: SocketMessage) {
        
    }
}
