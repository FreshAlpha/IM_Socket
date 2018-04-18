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
    required init(wiht dicJson: JSON) {
        userID = dicJson["_id"].stringValue
        username = dicJson["name"].stringValue
        sex = dicJson["sex"].intValue
        age = dicJson["age"].intValue
        email = dicJson["email"].stringValue
    }
}
