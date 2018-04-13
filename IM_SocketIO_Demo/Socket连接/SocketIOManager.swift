//
//  SocketIOManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/10.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SocketIO

class WeakSocketDelegate: NSObject {
    weak var delegate: SocketIOManagerDelegate?
    required init(delegate: SocketIOManagerDelegate?) {
        self.delegate = delegate
    }
}
class SocketIOManager: NSObject {
    private var delegates = [WeakSocketDelegate]()
    private static let sharedInstance = SocketIOManager()
    private var sessionID: String?
    private var manager = SocketManager(socketURL: URL(string: "http://123.206.136.17:8080")!, config: [.log(true), .forcePolling(true)])
    private var socket: SocketIOClient!
    private override init() {
        super.init()
        self.socket = manager.defaultSocket
        self.handleServerEvents()
        
    }
    class func shared() -> SocketIOManager {
        return sharedInstance
    }
    func addDelegate(delegate: SocketIOManagerDelegate) {
        self.delegates.append(WeakSocketDelegate(delegate: delegate))//防止数组直接放delegate，强引用外部对象。
    }
    func connect(with sessionID: String) {
        self.sessionID = sessionID
       socket.connect()
    }
    func disconnect() {
        socket.disconnect()
    }
    func sendData(_ cmd: String,  _ data: String) {
        socket.emit(cmd, with: [data])
    }
    
    
    
    
}
//业务层
extension SocketIOManager {
    //
    func handleServerEvents() {
        socket.on(clientEvent: .connect) { (data, ack) in
            print("socket连上")
            guard let sessionID = self.sessionID else {
                return
            }
            self.sendSessionID(sessionID)//服务端必须要验证sessionID，否则会断开连接(服务端说的，但是经过验证很久都没断开)
            
        }
        
        socket.onAny { (response) in
            print("服务端响应")
            print("----------------------")
            print(response)
            print("=======================")
            guard response.event != "statusChange" else {return}
            guard response.event != "ping" else {return}
            guard response.event != "connect" else {return}
            guard response.event != "pong" else {return}
            self.delegates.forEach({ (delegator) in
                guard let delegate = delegator.delegate else {return}
                delegate.reveiveData(response)
            })
        }
 
        socket.on("auth-s") { (data, ack) in
            print("认证结果")
            self.receiveServerAuthMsg(data)
        }
        socket.on("saoff") { (data, ack) in
            print("离线消息")
            self.receiveServerOfflineMsg(data)
        }
        socket.on("shistory") { (data, ack) in
            print("历史消息")
            self.receiveServerHistoryMsg(data)
        }
    }
    //认证，传sessionid
    private func sendSessionID(_ sessionID: String) {
        socket.emit("auth-c", with: [["sessionid" : sessionID]])
    }
    //收到服务端认证结果
    func receiveServerAuthMsg(_ data: [Any]) {
        print(data)
        self.delegates.forEach({ (delegator) in
            delegator.delegate?.reveiveAuthResult(data)
        })
    }
  
    //发送服务端：获取离线消息
    func sendFetchOfflineMsg(_ sessionID: String, userID: String) {
        socket.emit("caoff", with: [["from": userID, "to": "server"]])
    }
    //收到服务端发送的离线消息
    func receiveServerOfflineMsg(_ data: [Any]) {
        print(data)
        self.delegates.forEach({ (delegator) in
            delegator.delegate?.reveiveOfflineMsg(data)
        })
    }
    //发送服务端：历史消息
    func sendFetchHistoryMsg(_ sessionID: String, userID: String) {
        socket.emit("chistory", with: [["from": userID, "to": "server"]])
    }
    //收到服务端发送的离线消息
    func receiveServerHistoryMsg(_ data: [Any]) {
        print(data)
    }
}
protocol SocketIOManagerDelegate: class {
    func reveiveData(_ data: SocketAnyEvent)
    func reveiveAuthResult(_ data: [Any])
    func reveiveOfflineMsg(_ data: [Any])
    func reveiveFriendsMsg(_ data: [Any])
}

