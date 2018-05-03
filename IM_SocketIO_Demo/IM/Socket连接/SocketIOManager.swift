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
    private var manager: SocketManager?
     var socket: SocketIOClient!
    private let httpConnect = HttpConnect()
//PUBLIC
    public let chatManager = SocketChatManager()
    public let contactManager = SocketContactManager()
    private override init() {
        super.init()
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
    private func initSocketManager(with sessionID: String, userID uid: Int) {
        self.manager = SocketManager(socketURL: URL(string: "http://123.206.136.17:8111")!, config: [.log(true), .connectParams(["token": sessionID, "uid": uid]), .path("/websocket/")])//, .forceWebsockets(true)
        self.socket = manager!.socket(forNamespace: "/")
        self.handleServerEvents()
        self.connect()
    }
}
extension SocketIOManager {
    //注册
    func register(with userName: String, password pwd: String, email myEmail: String, age myAge: Int, sex mySex: Int,  callBack: ResultHandler?) {
        httpConnect.register(username: userName, pwd: pwd, email: myEmail, age: myAge, sex: mySex) { (error) in
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
            guard let session = UserInfo.shared().sessionID, UserInfo.shared().userId != -1 else {
                callBack?(.unkownedError)
                return
            }
            self.initSocketManager(with: session, userID: UserInfo.shared().userId)
            callBack?(error)
        }
    }
}

