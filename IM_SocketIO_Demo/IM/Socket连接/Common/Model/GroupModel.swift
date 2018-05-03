//
//  GroupModel.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/5/2.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SwiftyJSON
class GroupModel: NSObject {
    var groupID = ""
    var name = ""
    var remark = ""
    var dateTime = ""
    var owner = -1
    var type = GroupPermissonType.common
    convenience init?(with json: JSON?) {
        guard let json = json else {
            return nil
        }
        self.init()
        groupID = json["_id"].stringValue
        name = json["name"].stringValue
        remark = json["remark"].stringValue
        dateTime = json["dateTime"].stringValue
        owner = json["owner"].intValue
        type = owner == UserInfo.shared().userId ? .owner : .common
    }
}

enum GroupPermissonType {
    case common
    case manager
    case owner
}
