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
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var inputTF: UITextField!
    var invationArray: [ContactModel] = {
        let array = SocketIOManager.shared().contactManager.getInvitations()
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.register(UINib(nibName: "AddFriendCell", bundle: nil), forCellReuseIdentifier: "AddFriendCell")
        SocketIOManager.shared().contactManager.addDelegate(self)
    }

    @IBAction func addFriend(_ sender: Any) {
        self.addFriend()
    }
    func addFriend() {
        let friendID: String
        if let text = inputTF.text, text.count > 0 {
            friendID = text
        } else {
            friendID = "5acdbddd15256f119f596567" //不填就加175账号
        }
        SocketIOManager.shared().contactManager.requestForAddingFriend(by: friendID, messsage: "hello, i'm from ios") { (contact, error) in
            guard case .success = error, let contact = contact else {return}
            self.handleNew(contact)
        }
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
        addCell.configureCell(with: model) {//同意添加
            SocketIOManager.shared().contactManager.approveMakingFriend(by: model.from, completion: { (error) in
                guard case .success = error else {return}
                model.contactType = .approveFriend
                self.mainTable.reloadRows(at: [indexPath], with: .none)
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
extension FriendsMessageVC {
    func handleNew(_ contact: ContactModel) {
        let resultType = self.invationArray.addContact(contact)
        if resultType != .noChange {
            self.mainTable.reloadData()
        }
    }
}
extension FriendsMessageVC: SocketContactManagerDelegate {
    //新的好友请求
    func receiveFriendInvation(_ contact: ContactModel) {
        self.handleNew(contact)
    }
    //别人同意你的好友请求
    func receiveFriendApproved(_ contact: ContactModel) {
        self.handleNew(contact)
    }
}
