//
//  SocketMessageModel.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/16.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

struct SocketMessageModel {
    let isSend: Bool
    let eventName: MessageType
}
enum MessageType {
    case friendInvation
    case offlineMsg
    case historyMsg
}
