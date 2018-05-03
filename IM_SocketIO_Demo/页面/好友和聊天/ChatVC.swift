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
    @IBOutlet weak var inputBottomConstaint: NSLayoutConstraint!
    private let friendID: Int
    private let socketIOMgr = SocketIOManager.shared()
    private var chatArray = [SocketMessage]()
    private let conversation: SocketConversationModel
    required init(with friendID: Int) {
        self.friendID = friendID
        self.conversation = socketIOMgr.chatManager.getConversation(with: friendID)
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(friendID)"
//        self.chatArray = socketMgr.chatMessages(with: friendID)
        mainTable.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "myChat")
        mainTable.register(UINib(nibName: "OtherChatCell", bundle: nil), forCellReuseIdentifier: "OtherChat")
        socketIOMgr.chatManager.addDelegate(self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyBoard(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(_:)), name: .UIKeyboardWillHide, object: nil)
        self.conversation.fetchMessageFrom(nil, 10, completion: { (messages, error) in
            guard let messages = messages else {
                return
            }
            self.chatArray = messages
            self.mainTable.reloadData()
            if case .noHistoryMessage = error {
                print("没有历史消息，table的头不用下拉加载了")
            }
        })
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
        socketIOMgr.chatManager.sendMessage(msgModel)
        self.inputTF.text = nil
    }
    @objc private func showKeyBoard(_ noti: NSNotification) {
        guard let rectValue = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
        let height = rectValue.cgRectValue.size.height
        self.inputBottomConstaint.constant = height
        
    }
    @objc private func hideKeyboard(_ noti: NSNotification) {
        guard noti.userInfo != nil else {
            return
        }
        self.inputBottomConstaint.constant = 40
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
        let model: SocketMessage = chatArray[indexPath.row]
        if model.direction == .send {
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
        return 100
    }
}
extension ChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendMessage()
        return true
    }
}
extension ChatVC: SocketChatManagerDelegate {
    func receiveCommonChatMessage(_ message: SocketMessage) {
        chatArray.append(message)
        self.mainTable.reloadData()
        guard chatArray.count > 0 else {
            return
        }
        self.mainTable.scrollToRow(at: IndexPath(item: chatArray.count - 1, section: 0), at: .top, animated: true)
    }
}

