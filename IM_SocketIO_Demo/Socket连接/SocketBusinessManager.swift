//
//  SocketBusinessManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class SocketBusinessManager: NSObject {
    private let socketMgr = SocketIOManager.shared()
    private let user = UserInfo.shared()
    static let singleTon = SocketBusinessManager()
    class func shared() -> SocketBusinessManager {
        return singleTon
    }
    func connect() {
        guard let sessionID = user.sessionID else {return}
        socketMgr.connect(with: sessionID)
    }
    func disconnect() {
        guard let _ = user.sessionID else {return}
        socketMgr.disconnect()
    }
}
