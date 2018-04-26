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
    
    var socketResultCode: SocketErrorType {
        guard self.statusCode == 200 else {
            return .noCode
        }
        guard let code = responseJSON?["code"].int else {
            return .noCode
        }
        guard let codeType = SocketErrorType(rawValue: code) else {
            return .noCode
        }
        return codeType
    }
    
}

