//
//  SocketGroupManager.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/5/2.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
class WeakGroupDelegate: NSObject {
    weak var delegate: SocketGroupManagerDelegate?
    
    required init(delegate: SocketGroupManagerDelegate?) {
        self.delegate = delegate
    }
}
class SocketGroupManager: NSObject {
    private let httpConnect = HttpConnect()
    var weakDelegates = [WeakGroupDelegate]() //外部调用方法的代理
    
}
extension SocketGroupManager {
    //创建群组
    func creatGroup(with groupName: String, remark mark: String, completion aCompletion: GroupHandler?) {
        self.httpConnect.createGroup(with: groupName, and: mark) { (group, error) in
            aCompletion?(group, error)
        }
    }
    //搜索群组
    func searchGroup(by groupName: String, completion aCompletion: SearchGroupHandler?) {
        self.httpConnect.searchGroup(with: groupName, page: 0, pagesize: 10) { (groups, error) in
            aCompletion?(groups, error)
        }
    }
    //申请加入群组
    func joinGroup(with ownerID: String, groupID gid: String, message msg: String, completion aCompletion: ResultHandler?) {
        self.httpConnect.joinGroup(with: ownerID, groupID: gid, message: msg) { (error) in
            aCompletion?(error)
        }
    }
}
