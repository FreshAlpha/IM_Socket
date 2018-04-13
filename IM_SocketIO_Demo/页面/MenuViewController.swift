//
//  MenuViewController.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "菜单"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1001:
            break
        case 1002:
            break
        case 1003:
            break
        case 1004:
            break
        case 1005:
            break
        case 1006:
            break
        case 1007:
            break
        default:
            break
        }
        
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
