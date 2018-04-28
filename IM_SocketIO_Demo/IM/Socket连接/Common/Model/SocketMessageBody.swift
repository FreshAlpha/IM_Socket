//
//  SocketMessageBody.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/27.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
@objc enum MessageBodyType: NSInteger {
    case text = 0
    case image = 1
    case video = 2
    case location = 3
    case voice = 4
    case file = 5
    case cmd = 6
}
protocol SocketMessageBody: class {
    var bodyType: MessageBodyType {get}
}


class SocketTextBody: SocketMessageBody {
    var bodyType: MessageBodyType {
        return .text
    }
    var text: String = ""
    convenience init(with text: String) {
        self.init()
        self.text = text
    }
    
}
extension SocketTextBody: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = SocketTextBody()
        copy.text = text
        return copy
    }
}
