//
//  ViewController.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/10.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import SocketIO
import Moya
import SwiftyJSON
class ViewController: BaseViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var psdTF: UITextField!
    private let userInfo = UserInfo.shared()
    private let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    //登录
    @IBAction func login(_ sender: Any) {
        guard let username = usernameTF.text, let psd = psdTF.text else {
            return
        }
        provider.request(.login(userName: username, psd: psd)) { (result) in
            guard case .success(let response) = result else {return}
            guard response.serverCodeType == .success else {return}
            print("登录成功")
            print(response.responseJSON as Any)
            self.requestUserInfo()
            self.getSessionID()
        }
    }
    private func requestUserInfo() {
        provider.request(.userInfo, completion: { (result) in
            guard case .success(let response) = result else {return}
            guard let responseJSON = response.responseJSON else {return}
//            guard response.serverCodeType == .success else {return}
            print("拿到用户信息")
            print(responseJSON)
            self.handleUserInfo(responseJSON)
        })
    }
    private func getSessionID() {
        provider.request(.getSessionID) { (result) in
            guard case .success(let response) = result else {return}
            guard response.serverCodeType == .success else {return}
            print("拿到sessionID")
            print(response.responseJSON as Any)
            self.userInfo.sessionID = response.responseJSON?["id"].string
            SocketBusinessManager.shared().connect()
            self.pushToMenu()
        }
    }
    private func pushToMenu() {
        let menuVC = MenuViewController()
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    private func handleUserInfo(_ responseJSON: JSON) {
        userInfo.name = responseJSON["name"].stringValue
        userInfo.email = responseJSON["email"].stringValue
        userInfo.userId = responseJSON["_id"].stringValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


