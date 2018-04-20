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
class SocketBusinessManager: NSObject {
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
        self.socketMgr.delegate = self
        self.registerCommon()
    }
    
    //MARK: -基本连接方法
    func connect() {
        guard let _ = user.sessionID else {return}
        socketMgr.connect()
    }
    func disconnect() {
        socketMgr.disconnect()
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
//MARK: -跟服务器遵循相关文本协议，定制的业务方法
extension SocketBusinessManager {
    //发送服务端：获取离线消息
    func fetchOfflineMsg() {
        self.socketMgr.socket.emit(SocketBusinessManager.offlineMsg.emitEvent, with: [["from": user.userId, "to": "server"]])
    }
    //发送服务端：获取历史好友消息
    func fetchHistoryMsg(from friendID: String) {
        let dic = ["to": friendID, "type": "friend"]
        let finalDic = self.addCommonParameters(dic)
        self.socketMgr.socket.emit(SocketBusinessManager.historyMsg.emitEvent, with: [finalDic])
    }
    //发送消息
    func sendMessage(model: MessageModel) {
        self.socketMgr.socket.emit(SocketBusinessManager.sendMessage.emitEvent, with: [model.mapDic()])
    }
    func addCommonParameters(_ dic: [String: Any])-> [String: Any] {
        var commonDic: [String : Any] = ["id": 0, "from": user.userId, "date": 1524021772436, "len": 10]
        commonDic.merge(dic) { $1 }
        
        return commonDic
    }
}
extension SocketBusinessManager {
    //注册接收消息方法
    private func registerCommon() {
        register(SocketBusinessManager.auth)
        register(SocketBusinessManager.offlineMsg)
        register(SocketBusinessManager.historyMsg)
        register(SocketBusinessManager.friendInvitation)
        register(SocketBusinessManager.friendApproved)
        register(SocketBusinessManager.sendMessage)
    }
    private func register(_ function: SocketFunction) {
        self.socketMgr.socket.on(function.responseEvent) { (data: [Any], ack: SocketAckEmitter) in
            function.handler(data, self)
        }
    }
}
extension SocketBusinessManager: SocketIOManagerSettingDelegate {
    //认证，传sessionid
    func connectSuccess() {
        guard let sessionID = user.sessionID else {return}
        self.socketMgr.socket.emit(SocketBusinessManager.auth.emitEvent, with: [["sessionid" : sessionID]])
    }
}
protocol SocketBusinessDelegate: class {
    //MARK: -目前只写一个方法，通过model的messageType区分不同消息，后续如果有扩展，再添加其它方法
    func receiveData(_ data: SocketMessageModel)
    func receiveFriendInvation(_ data: SocketSystemMessage)
    func receiveFriendApprove(_ data: SocketSystemMessage)
    func receiveMessage(_ data: SocketSystemMessage)
    func receiveCommentChatMessage(_ message: MessageModel)
    func receiveHistoryChatMessage(_ message: MessageModel) 
}
extension SocketBusinessDelegate {
    func receiveData(_ data: SocketMessageModel) {
        
    }
    func receiveFriendInvation(_ data: SocketSystemMessage) {
         
    }
    func receiveFriendApprove(_ data: SocketSystemMessage) {
        
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
