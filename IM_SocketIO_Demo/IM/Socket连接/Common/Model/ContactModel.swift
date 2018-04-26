//
//  ConnectModel.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/26.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SwiftyJSON
class ContactModel: NSObject {
    var from: String = "" //朋友
    var to: String = "" //我
    var msg: String = ""
    var contactType: ContactType = .nothing
    convenience init(bySocket json: JSON, contact contactType: ContactType) {
        self.init()
        from = json["from"].stringValue
        to = json["to"].stringValue
        msg = json["msg"].stringValue
        self.contactType = contactType
    }
    convenience init(byHttp from: String, contact contactType: ContactType, message msg: String?) {
        self.init()
        self.from = from
        self.to = UserInfo.shared().userId
        if let msg = msg {
            self.msg = msg
        }
        self.contactType = contactType
    }
}
extension ContactModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ContactModel()
        copy.from = from
        copy.to = to
        copy.contactType = contactType
        copy.msg = msg
        return copy
    }
}
@objc enum ContactType: NSInteger {
    case nothing = 0
    case friendInvitation = 1 //别人申请加我好友，还不是好友
    case approveFriend = 2 //我同意别人的好友请求，真的是好友了
    case selfRequestFriend = 3 //我申请加别人好友，还不是好友
    case friendAppriveMe = 4//别人同意我的好友请求，真的是好友了
}
