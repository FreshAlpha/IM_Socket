//
//  SocketErrorType.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/24.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
@objc
enum SocketErrorType: NSInteger {
    case noCode = -2 //没有返回code,或者code超出范围
    case unkownedError = -1
    case failure = 0
    case success = 1
    case accountNotExist = 2
    case wrongPassword = 3
    case emailExist = 4
    case verificationError = 5
    case emilNotExist = 6
    case notLogin = 7
    case notExist = 8
    case dataIllegal = 9 //数据格式非法
    case securityLack = 10 //安全验证失败
    case haveAddFriend = 11
    case largeFile = 12 //文件过大
    case haveJoinGroup = 13 //已经添加该群
    
}
extension SocketErrorType {
    var errorLog: String {
        switch self {
        case .unkownedError:
            return "服务器未知错误"
        default:
            return ""
        }
    }
}

