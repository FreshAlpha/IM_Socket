//
//  FriendsMessageVC.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/17.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import Moya
class FriendsMessageVC: BaseViewController {
    let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    private let socketMgr = SocketBusinessManager.shared()
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var inputTF: UITextField!
    var invationArray: [SocketSystemMessage] = {
        let array = SocketBusinessManager.shared().friendInvations
        return array
    }()
    var friendsArray = [SocketSystemMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.register(UINib(nibName: "AddFriendCell", bundle: nil), forCellReuseIdentifier: "AddFriendCell")
        socketMgr.addDelegate(delegate: self)
    }

    @IBAction func addFriend(_ sender: Any) {
        self.addFriend()
    }
    func addFriend() {
        let friendID: String = inputTF.text ?? "5acdbddd15256f119f596567" //不填就加175账号
        IMManager.shared().addFriend(by: friendID)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

extension FriendsMessageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invationArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addCell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell", for: indexPath) as! AddFriendCell
        let model = invationArray[indexPath.row]
        addCell.configureCell(with: model) {
            IMManager.shared().approveMakingFriend(by: model.fromID, callBack: { (isSuccess) in
                guard isSuccess else {return}
                self.invationArray.remove(at: indexPath.row)
                self.mainTable.reloadData()
            })
        }
        return addCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
extension FriendsMessageVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.addFriend()
        return true
    }
}
extension FriendsMessageVC: SocketBusinessDelegate {
   //新的好友请求
    func receiveFriendInvation(_ data: SocketSystemMessage) {
        self.invationArray.insert(data, at: 0)
        self.mainTable.reloadData()
    }
   
}
