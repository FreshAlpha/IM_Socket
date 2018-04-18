//
//  ChatVC.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/17.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class ChatVC: BaseViewController {
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var mainTable: UITableView!
    private let friendID: String
    private let socketMgr = SocketBusinessManager.shared()
    private var chatArray = [MessageModel]()
    required init(with friendID: String) {
        self.friendID = friendID
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = friendID
        self.chatArray = socketMgr.chatMessages(with: friendID)
        mainTable.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "myChat")
        mainTable.register(UINib(nibName: "OtherChatCell", bundle: nil), forCellReuseIdentifier: "OtherChat")
        socketMgr.addDelegate(delegate: self)
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func sendMessage() {
        guard let message = self.inputTF.text else {
            return
        }
        let msgModel = MessageModel(from: UserInfo.shared().userId, to: friendID, identifier: "myInfo", msg: message)
        socketMgr.sendMessage(model: msgModel)
    }

}
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: MessageModel = chatArray[indexPath.row]
        if model.isSender {
            let cell: ChatCell = tableView.dequeueReusableCell(withIdentifier: "myChat", for: indexPath) as! ChatCell
            cell.configureCell(with: model)
            return cell
        } else {
            let cell: OtherChatCell = tableView.dequeueReusableCell(withIdentifier: "OtherChat", for: indexPath) as! OtherChatCell
            cell.configureCell(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
}
extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendMessage()
        return true
    }
}
extension ChatVC: SocketBusinessDelegate {
    func receiveCommentChatMessage(_ message: MessageModel) {
        chatArray.append(message)
        self.mainTable.reloadData()
    }
}
