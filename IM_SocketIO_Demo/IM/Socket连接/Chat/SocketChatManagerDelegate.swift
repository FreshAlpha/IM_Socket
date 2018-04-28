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
}
extension SocketChatManagerDelegate {
    func receiveCommonChatMessage(_ message: SocketMessage) {
        
    }
}
