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
    let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    @IBOutlet weak var searchTF: UITextField!
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
            socketMgr.fetchHistoryMsg()
        case 1003:
            break
        case 1004:
            requestForAddFriend(friendID: "5acdbddd15256f119f596567")//搜索好友请求失败，直接添加好友
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
    private func requestSearchFriends() {
        guard let searchName = searchTF.text else {return}
        provider.request(.searchName(keyword: searchName)) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {
                print("查找失败")
                return
                
            }
            print("查找成功")
            if let friendID = response.responseJSON?.array?.first?.dictionary?["id"]?.string {
                self.requestForAddFriend(friendID: friendID)
            }
            
        }
    }
    private func requestForAddFriend(friendID: String) {
        provider.request(.addFriend(friendID: friendID, msg: "hello，来自iOS的朋友")) { (result) in
            guard case .success(let response) = result, response.serverCodeType == .success else {
                print("添加朋友申请失败")
                return
            }
            print("添加好友申请成功")
        }
    }
    
}
extension MenuViewController: SocketBusinessDelegate {
    func reveiveData(_ data: [Any]) {
        
    }
}
