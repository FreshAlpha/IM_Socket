//
//  Response+UserNetwork.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
extension Response {
    var responseJSON: JSON? {
        guard self.statusCode == 200 else {return nil}
        guard let responseMapJSON = try? self.mapJSON() else {return nil}
        return JSON(responseMapJSON)
    }
    var serverCodeType: ResponseCode {
        guard self.statusCode == 200 else {
            return .serverNot200
        }
        guard let code = responseJSON?["code"].int, code == 1 else {
            return .invalidResponse
        }
        return .success
    }
    var serverCode: Int? {
        return responseJSON?["code"].int
    }
    
}
enum ResponseCode {
    case serverNot200
    case success
    case invalidResponse
}
