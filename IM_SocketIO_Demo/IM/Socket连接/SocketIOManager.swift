//
//  SocketIOManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/10.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SocketIO


class SocketIOManager: NSObject {
    
    private static let sharedInstance = SocketIOManager()
    
    private var manager = SocketManager(socketURL: URL(string: "http://123.206.136.17:8080")!, config: [.log(true)])
     var socket: SocketIOClient!
    private let httpConnect = HttpConnect()
//PUBLIC
    public let chatManager = SocketChatManager()
    public let contactManager = SocketContactManager()
    private override init() {
        super.init()
        self.socket = manager.defaultSocket
        self.handleServerEvents()
    }
    class func shared() -> SocketIOManager {
        return sharedInstance
    }
    func connect() {
       socket.connect()
    }
    func disconnect() {
        socket.disconnect()
    }
    
    func sendData(_ cmd: String,  _ data: String) {
        socket.emit(cmd, with: [data])
    }
    private func handleServerEvents() {
        socket.on(clientEvent: .connect) { (data, ack) in
            print("socket连上")
            let emitType = SocketEmitType.auth
            self.socket.emit(emitType.cmd, with: emitType.parameters)
        }
        socket.on("auth-s") { (data, ack) in
            print("认证结果")
        }
        registerChatEvents()
        registerContactEvents()
    }
    //注册接收消息方法
    private func registerChatEvents() {
        registerChat(SocketChatManager.reveiveMessage)
        registerChat(SocketChatManager.historyMsg)
        registerChat(SocketChatManager.offlineMsg)
    }
    private func registerChat(_ function: SocketReceiveFuntion<SocketChatManager>) {
        socket.on(function.cmd) { (data: [Any], ack: SocketAckEmitter) in
            function.handler(data, self.chatManager)
        }
    }
    //注册接收消息方法
    private func registerContactEvents() {
        registerContact(SocketContactManager.friendInvitation)
        registerContact(SocketContactManager.friendApproved)
    }
    private func registerContact(_ function: SocketReceiveFuntion<SocketContactManager>) {
        socket.on(function.cmd) { (data: [Any], ack: SocketAckEmitter) in
            function.handler(data, self.contactManager)
        }
    }
    
}
extension SocketIOManager {
    //注册
    func register(with userName: String, password pwd: String, callBack: ResultHandler?) {
        httpConnect.register(username: userName, pwd: pwd) { (error) in
            callBack?(error)
        }
    }
    //登录
    func login(with userName: String, password pwd: String, callBack: ResultHandler?) {
        httpConnect.login(username: userName, pwd: pwd) { (error) in
            guard case .success = error else {
                callBack?(error)
                return
            }
            self.socket.connect()
            callBack?(error)
        }
    }
}

