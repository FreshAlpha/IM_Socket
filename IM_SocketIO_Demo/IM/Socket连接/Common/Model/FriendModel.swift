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
    let fid: Int //好友关系表ID（给服务用）
    let userID: Int
    let username: String
    let remark: String //好友备注
    let makeDate: String //加好友时间
    let type: Int //扩展用，类似于VIP等等
    let sex: Int
    let regisDate: String
    /*
    let age: Int
    let email: String
 */
    required init(with dicJson: JSON) {//好友列表
        fid = dicJson[""].intValue
        userID = dicJson["uid"].intValue
        username = dicJson["name"].stringValue
        remark = dicJson["hremark"].stringValue
        makeDate = dicJson["mydate"].stringValue
        type = 0
        sex = 0
        regisDate = ""
        /*
        sex = dicJson["sex"].intValue
        age = dicJson["age"].intValue
        email = dicJson["email"].stringValue
        */
    }
    required init(bysearch result: JSON) { //搜索关键词拿到的搜索结果列表（添加好友时）
        userID = result["id"].intValue
        username = result["name"].stringValue
        type = result["type"].intValue
        sex = result["sex"].intValue
        regisDate = result["cdate"].stringValue
        remark = result["remark"].stringValue
        fid = 0
        makeDate = ""
        /*
        sex = 0
        age = 0
        email = ""
 */
    }
}
