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
}
//MARK: -跟服务器遵循相关文本协议，定制的业务方法
extension SocketBusinessManager {
    //发送服务端：获取离线消息
    func fetchOfflineMsg() {
        self.socketMgr.socket.emit(SocketBusinessManager.offlineMsg.emitEvent, with: [["from": user.userId, "to": "server"]])
    }
    //发送服务端：获取历史消息
    func fetchHistoryMsg() {
        self.socketMgr.socket.emit(SocketBusinessManager.historyMsg.emitEvent, with: [["from": user.userId, "to": "server"]])
    }
}
extension SocketBusinessManager {
    //注册接收消息方法
    private func registerCommon() {
        register(SocketBusinessManager.auth)
        register(SocketBusinessManager.offlineMsg)
        register(SocketBusinessManager.historyMsg)
        register(SocketBusinessManager.friendInvitation)
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
    func reveiveData(_ data: SocketMessageModel)
    func reveiveFriendInvation(_ data: [Any])
}
extension SocketBusinessDelegate {
    func reveiveFriendInvation(_ data: [Any]) {
        
    }
}
