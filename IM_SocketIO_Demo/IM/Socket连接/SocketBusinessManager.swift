//
//  SocketBusinessManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SocketIO

final class SocketBusinessManager: NSObject {
    private let socketMgr = SocketIOManager.shared()
    private let user = UserInfo.shared()
    var chatMessages = [MessageModel]()
    static let singleTon = SocketBusinessManager()
    class func shared() -> SocketBusinessManager {
        return singleTon
    }
    private override init() {
        super.init()
       
    }
    
}

extension SocketBusinessManager {
    //与某个朋友的对话
    func chatMessages(with friendID: Int)-> [MessageModel] {
       return self.chatMessages.filter { (model) -> Bool in
            return model.from == friendID || model.to == friendID
        }
    }
}
extension DispatchQueue {
    private static var onceTracker = [String]()
    public class func once(token: String, block: (()->())) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}
