//
//  FriendsListVC.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/18.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class FriendsListVC: BaseViewController {

    @IBOutlet weak var mainTable: UITableView!
    private var dataArray = [FriendModel]()
    private var statusDic = [String : Int]()
    private var historyArray = [MessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.register(UITableViewCell.self, forCellReuseIdentifier: "friendsListCell")
        // Do any additional setup after loading the view.
        SocketBusinessManager.shared().addDelegate(delegate: self)
        IMManager.shared().getFriendList { (array) in
            guard let array = array else {return}
            self.dataArray = array
            self.dataArray.forEach({ (friend) in
                SocketBusinessManager.shared().fetchHistoryMsg(from: friend.userID)
            })
            self.mainTable.reloadData()
        }
    }
    private func createHistoryStatus() {
        self.dataArray.forEach { (model) in
            let count = self.getHistoryMessagesCount(by: model.userID)
            if count > 0 {
                statusDic[model.userID] = count
            }
        }
    }
    private func getHistoryMessagesCount(by friendID: String) -> Int {
        var count = 0
        self.historyArray.forEach { (model) in
            if model.from == friendID {
                count += 1
            }
        }
        return count
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension FriendsListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsListCell", for: indexPath)
        let friend: FriendModel = dataArray[indexPath.row]
        let messageHistory: String
        if let count = statusDic[friend.userID] {
            messageHistory = "(\(count)条未读消息)"
        } else {
            messageHistory = ""
        }
        cell.textLabel?.text = friend.username + messageHistory
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend: FriendModel = dataArray[indexPath.row]
        self.statusDic.removeValue(forKey: friend.userID)
        mainTable.reloadRows(at: [indexPath], with: .none)
        let chatVC = ChatVC(with: friend.userID)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
extension FriendsListVC: SocketBusinessDelegate {
    func receiveHistoryChatMessage(_ message: MessageModel) {
        self.historyArray.append(message)
        self.createHistoryStatus()
        self.mainTable.reloadData()
    }
}
