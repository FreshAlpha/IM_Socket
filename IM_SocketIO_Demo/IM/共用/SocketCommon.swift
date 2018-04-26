//
//  SocketCommon.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/25.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation

typealias ResultHandler = (SocketErrorType)->()
typealias FriendsHandler = ([FriendModel]?, SocketErrorType) -> ()
typealias ContactHandler = (ContactModel?, SocketErrorType)->()
