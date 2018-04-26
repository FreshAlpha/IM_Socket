//
//  SocketChatManagerProtocol.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
protocol SocketChatManagerDelegate: class {
    func receiveMessages(_ messages: [MessageModel])
}
extension SocketChatManagerDelegate {
    func receiveMessages(_ messages: [MessageModel]) {
        
    }
}
