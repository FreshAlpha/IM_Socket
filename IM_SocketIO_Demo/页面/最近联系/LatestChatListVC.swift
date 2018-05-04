//
//  LatestChatListVC.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/5/4.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class LatestChatListVC: BaseViewController {

    @IBOutlet weak var mainTable: UITableView!
    private let socketIOMgr = SocketIOManager.shared()
    private var conversationList = [SocketConversationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conversationList = socketIOMgr.chatManager.getAllConversations()
        socketIOMgr.chatManager.addDelegate(self)
        // Do any additional setup after loading the view.
    }

}
extension LatestChatListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension LatestChatListVC: SocketChatManagerDelegate {
    //有新会话
    func newConversation(_ conversation: SocketConversationModel) {
        self.conversationList.insert(conversation, at: 0)
        self.mainTable.reloadData()
    }
    //单聊收到消息，要将当前会话放到最前面
    func receiveCommonChatMessage(_ message: SocketMessage) {
        self.updateConversation(with: message)
    }
    //群聊收到消息，要将当前会话放到最前面
    func receiveGroupChatMessage(_ message: SocketMessage) {
        self.updateConversation(with: message)
    }
    private func updateConversation(with newMessage: SocketMessage) {
        var targetIdx = 0
        for (idx, message) in self.conversationList.enumerated() {
            if message.conversationID == newMessage.conversationID {
                targetIdx = idx
                break
            }
        }
        //放到最前
        if targetIdx != 0 {
            let targetConversation = self.conversationList[targetIdx]
            self.conversationList.remove(at: targetIdx)
            self.conversationList.insert(targetConversation, at: 0)
            self.mainTable.reloadData()
        }
    }
}
