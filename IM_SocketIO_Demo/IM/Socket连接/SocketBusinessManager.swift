//
//  SocketBusinessManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SocketIO
class WeakSocketDelegate: NSObject {
    weak var delegate: SocketBusinessDelegate?
    required init(delegate: SocketBusinessDelegate?) {
        self.delegate = delegate
    }
}
final class SocketBusinessManager: NSObject {
    private let socketMgr = SocketIOManager.shared()
    private let user = UserInfo.shared()
    var delegates = [WeakSocketDelegate]()
    public var friendInvations = [SocketSystemMessage]()
    var chatMessages = [MessageModel]()
    static let singleTon = SocketBusinessManager()
    class func shared() -> SocketBusinessManager {
        return singleTon
    }
    private override init() {
        super.init()
       
    }
    
//MARK: -想要收到消息，必须添加代理
    func addDelegate(delegate: SocketBusinessDelegate) {
        self.delegates.append(WeakSocketDelegate(delegate: delegate))//防止数组直接放delegate，强引用外部对象。
    }
    func delegateInvation(by friendID: String) {
        objc_sync_enter(self)
        var deleteIndex: Int?
        for (index, msg) in friendInvations.enumerated() {
            if friendID == msg.fromID {
                deleteIndex = index
            }
            break
        }
        if let deleteIdx = deleteIndex {
            friendInvations.remove(at: deleteIdx)
        }
        objc_sync_exit(self)
    }
    
}

extension SocketBusinessManager {
   
    private func register(_ function: SocketFunction) {
        self.socketMgr.socket.on(function.responseEvent) { (data: [Any], ack: SocketAckEmitter) in
            function.handler(data, self)
        }
    }
}

protocol SocketBusinessDelegate: class {
    //MARK: -目前只写一个方法，通过model的messageType区分不同消息，后续如果有扩展，再添加其它方法
    func receiveData(_ data: SocketMessageModel)
    func receiveMessage(_ data: SocketSystemMessage)
    func receiveCommentChatMessage(_ message: MessageModel)
    func receiveHistoryChatMessage(_ message: MessageModel) 
}
extension SocketBusinessDelegate {
    func receiveData(_ data: SocketMessageModel) {
        
    }
    func receiveMessage(_ data: SocketSystemMessage){
        
    }
    func receiveCommentChatMessage(_ message: MessageModel) {
        
    }
    func receiveHistoryChatMessage(_ message: MessageModel) {
        
    }
}
extension SocketBusinessManager {
    //与某个朋友的对话
    func chatMessages(with friendID: String)-> [MessageModel] {
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
