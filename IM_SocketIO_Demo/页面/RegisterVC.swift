//
//  RegisterVC.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/12.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit
import Moya
class RegisterVC: BaseViewController {
    let provider = MoyaProvider<UserApi>(plugins: [NetworkPlugin()])
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var psdTF: UITextField!
    @IBOutlet weak var psdReTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: Any) {
        guard let username = usernameTF.text else {
            return
        }
        guard let psd = psdTF.text, let rePsd = psdReTF.text, psd == rePsd else {return}
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
