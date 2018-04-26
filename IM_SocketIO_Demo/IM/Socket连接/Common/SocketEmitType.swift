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
    case offlineMessage
    case friendHistoryMessage(String)
    case groupHistoryMessage(String)
    
}
extension SocketEmitType {
    var cmd: String {
        switch self {
        case .sendMessage:
            return "cfmsg"
        case .offlineMessage:
            return "caoff"
        case .friendHistoryMessage, .groupHistoryMessage:
            return "chistory"
        }
    }
    var parameters: [Any] {
        switch self {
        case .sendMessage(let message):
            let dic = message.mapDic()
            return [dic]
        case .offlineMessage:
            let dic = ["from" : UserInfo.shared().userId, "to": "server"]
            return [dic]
        case .friendHistoryMessage(let friendID):
            let dic = ["to": friendID, "type": "friend"]
            let finalDic = self.addCommonParameters(dic)
            return [finalDic]
        case .groupHistoryMessage(let groupID):
            let dic = ["to": groupID, "type": "group"]
            let finalDic = self.addCommonParameters(dic)
            return [finalDic]
            
        }
    }
    func addCommonParameters(_ dic: [String: Any])-> [String: Any] {
        let now = Date()
        let timestamp = now.timeIntervalSince1970 * 1000 //取毫秒，单位毫秒
        var commonDic: [String : Any] = ["id": 0, "from": UserInfo.shared().userId, "date": timestamp, "len": 10]
        commonDic.merge(dic) { $1 }
        
        return commonDic
    }
}
