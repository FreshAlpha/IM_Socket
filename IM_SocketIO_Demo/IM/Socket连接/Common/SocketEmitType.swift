//
//  SocketEmitType.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
enum SocketEmitType {
    case sendMessage(MessageModel)
    case sendGroupMessage(MessageModel)
    /*
    case offlineMessage
    case friendHistoryMessage(String, Double?)
    case groupHistoryMessage(String, Double?)
    */
}
extension SocketEmitType {
    var cmd: String {
        switch self {
        case .sendMessage:
            return "f_msg"
        case .sendGroupMessage:
            return "g_msg"
            /*
        case .offlineMessage:
            return "caoff"
        case .friendHistoryMessage, .groupHistoryMessage:
            return "chistory"
 */
        }
    }
    var parameters: [Any] {
        switch self {
        case .sendMessage(let message):
            let dic = message.mapDic()
            return [dic]
        case .sendGroupMessage(let message):
            let dic: [String : Any] = ["id": "", "to_gid": message.to, "msg": message.msg, "mtype": 1]
            return [dic]
            /*
        case .offlineMessage:
            let dic: [String: Any] = ["from" : UserInfo.shared().userId, "to": "server"]
            return [dic]
        case .friendHistoryMessage(let friendID, let timestamp):
            let date: Double
            if let timestamp = timestamp {
                date = timestamp
            } else {
                let now = Date()
                date = now.timeIntervalSince1970 * 1000 //取毫秒，单位毫秒
            }
            let dic: [String: Any] = ["to": friendID, "type": "friend", "date": date]
            let finalDic = self.addCommonParameters(dic)
            return [finalDic]
        case .groupHistoryMessage(let groupID, let timestamp):
            let date: Double
            if let timestamp = timestamp {
                date = timestamp
            } else {
                let now = Date()
                date = now.timeIntervalSince1970 * 1000 //取毫秒，单位毫秒
            }
            let dic: [String: Any] = ["to": groupID, "type": "group", "date": date]
            let finalDic = self.addCommonParameters(dic)
            return [finalDic]
 */
        }
    }
    func addCommonParameters(_ dic: [String: Any])-> [String: Any] {
        var commonDic: [String : Any] = ["id": 0, "from": UserInfo.shared().userId, "len": 10]
        commonDic.merge(dic) { $1 }
        
        return commonDic
    }
}
