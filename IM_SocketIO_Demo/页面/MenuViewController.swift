//
//  MenuViewController.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import Moya
class MenuViewController: BaseViewController {
    
    @IBOutlet weak var friendsList: UIButton!
    private let socketMgr = SocketBusinessManager.shared()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "菜单"
        // Do any additional setup after loading the view.
        socketMgr.addDelegate(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            socketMgr.fetchOfflineMsg()
        case 1002:
            self.pushToFriendList()
        case 1003:
            break
        case 1004:
            self.pushToFriendInvationList()
            IMManager.shared().addFriend(by: "5acdbddd15256f119f596567")//搜索好友请求失败，直接添加好友（175的账号）
//            requestSearchFriends()
        case 1005:
            break
        case 1006:
            break
        case 1007:
            break
        default:
            break
        }
        
    }
    private func pushToFriendList() {
        let friendList = FriendsListVC()
        self.navigationController?.pushViewController(friendList, animated: true)
    }
    private func pushToFriendInvationList() {
        let friendsInvationVC = FriendsMessageVC()
        self.navigationController?.pushViewController(friendsInvationVC, animated: true)
    }
    
    
}
extension MenuViewController: SocketBusinessDelegate {
    func receiveFriendInvation(_ data: SocketSystemMessage) {
        print("来自好友申请")
        print(data)
    }
    func receiveFriendApprove(_ data: SocketSystemMessage) {
        print("好友同意添加请求")
        print(data)
    }
    
    func receiveData(_ data: SocketMessageModel) {
        switch data.eventName {
        case .friendInvation:
            print("有个好友申请")
        case .offlineMsg:
            print("离线消息")
        case .historyMsg:
            print("历史消息")
        }
    }
}
