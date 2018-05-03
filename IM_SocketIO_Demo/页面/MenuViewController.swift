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
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var friendsList: UIButton!
    private let socketMgr = SocketIOManager.shared()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "菜单"
        myLabel.text = "\(UserInfo.shared().name)：\(UserInfo.shared().userId)"
        // Do any additional setup after loading the view.
        socketMgr.chatManager.addDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            break
        case 1002:
            self.pushToFriendList()
        case 1003:
            break
        case 1004:
            self.pushToFriendInvationList()
        case 1005:
            break
        case 1006://创建群
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
extension MenuViewController: SocketChatManagerDelegate {
    
}

