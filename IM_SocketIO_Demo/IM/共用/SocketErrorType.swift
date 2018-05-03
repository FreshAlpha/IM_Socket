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
    case noHistoryMessage = -3
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
        case .failure:
            return "失败"
        case .success:
            return "成功"
        case .accountNotExist:
            return "用户不存在"
        case .wrongPassword:
            return "密码错误"
        case .emailExist:
            return "邮箱已存在"
        case .verificationError:
            return "验证码错误"
        case .emilNotExist:
            return "邮箱不存在"
        case .notExist:
            return "不存在"
        case .dataIllegal:
            return "数据格式非法"
        case .securityLack:
            return "安全验证失败"
        case .haveAddFriend:
            return "已添加好友"
        case .largeFile:
            return "文件过大"
        case .haveJoinGroup:
            return "已经添加该群"
        default:
            return ""
        }
    }
}

