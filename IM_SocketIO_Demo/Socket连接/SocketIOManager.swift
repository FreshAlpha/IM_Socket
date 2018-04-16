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
    private var manager = SocketManager(socketURL: URL(string: "http://123.206.136.17:8080")!, config: [.log(true), .forcePolling(true)])
    var socket: SocketIOClient!
    weak var delegate: SocketIOManagerSettingDelegate?
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
            self.delegate?.connectSuccess()
        }
        /*
         socket.onAny { (response) in
         print("服务端响应")
         print("----------------------")
         print(response)
         print("=======================")
         guard response.event != "statusChange" else {return}
         guard response.event != "ping" else {return}
         guard response.event != "connect" else {return}
         guard response.event != "pong" else {return}
         
         }
         */
        
    }
    
    
    
}

protocol SocketIOManagerSettingDelegate: class {
    func connectSuccess()//服务端必须要验证sessionID，否则会断开连接(服务端说的，但是经过验证很久都没断开)
    
}
