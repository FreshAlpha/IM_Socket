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
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.register(UITableViewCell.self, forCellReuseIdentifier: "friendsListCell")
        // Do any additional setup after loading the view.
        IMManager.shared().getFriendList { (array) in
            guard let array = array else {return}
            self.dataArray = array
            self.mainTable.reloadData()
        }
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
        cell.textLabel?.text = friend.username
        cell.detailTextLabel?.text = "年龄：\(friend.age)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend: FriendModel = dataArray[indexPath.row]
        let chatVC = ChatVC(with: friend.userID)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
