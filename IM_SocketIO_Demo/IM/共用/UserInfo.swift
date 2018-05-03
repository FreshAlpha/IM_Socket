//
//  UserInfo.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    var isLogin = false
    var name = ""
    var email = ""
    var userId = -1
    var sessionID: String?
    static let singleTon = UserInfo()
    private override init() {
        super.init()
    }
    class func shared() -> UserInfo {
        return singleTon
    }
}
