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
    
    private let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapToDismissKeyBoard))
        self.view.addGestureRecognizer(tap)
    }
    @objc func tapToDismissKeyBoard() {
        for aView in self.view.subviews {
            if let tf = aView as? UITextField {
                tf.resignFirstResponder()
            }
        }
    }
    //登录
    @IBAction func login(_ sender: Any) {
        guard let username = usernameTF.text, let pwd = psdTF.text else {
            return
        }
        IMManager.shared().login(username: username, pwd: pwd) { (success) in
            if success {
                self.showMenu()
            }
        }
    }
    private func showMenu() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let menuVC = MenuViewController()
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: menuVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


