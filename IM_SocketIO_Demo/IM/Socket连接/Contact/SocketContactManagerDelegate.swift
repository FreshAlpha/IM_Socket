//
//  SocketConnectManagerProtocol.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/25.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
protocol SocketContactManagerDelegate: class {
    //新的好友请求
    func receiveFriendInvation(_ contact: ContactModel)
    //别人同意你的好友请求
    func receiveFriendApproved(_ contact: ContactModel)
}
extension SocketContactManagerDelegate {
    //新的好友请求
    func receiveFriendInvation(_ contact: ContactModel) {
        
    }
    //别人同意你的好友请求
    func receiveFriendApproved(_ contact: ContactModel) {
        
    }
}
