//
//  FriendModel.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/18.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SwiftyJSON
class FriendModel: NSObject {
    let userID: String
    let username: String
    let sex: Int
    let age: Int
    let email: String
    let remark: String
    required init(with dicJson: JSON) {//好友列表
        userID = dicJson["_id"].stringValue
        username = dicJson["name"].stringValue
        sex = dicJson["sex"].intValue
        age = dicJson["age"].intValue
        email = dicJson["email"].stringValue
        remark = ""
    }
    required init(bysearch result: JSON) { //搜索关键词拿到的搜索结果列表（添加好友时）
        userID = result["id"].stringValue
        username = result["name"].stringValue
        remark = result["remark"].stringValue
        sex = 0
        age = 0
        email = ""
    }
}
