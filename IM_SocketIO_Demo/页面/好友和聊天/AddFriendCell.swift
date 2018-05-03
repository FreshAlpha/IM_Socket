//
//  AddFriendCell.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/17.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class AddFriendCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    private var btnBlock: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(with model: ContactModel, block: (()->())?) {
        nameLbl.text = "\(model.from)"
        msgLbl.text = model.msg
        var canClick = false
        submitBtn.isUserInteractionEnabled = false
        let btnTitle: String
        switch model.contactType {
        case .approveFriend:
            btnTitle = "已添加"
        case .friendAppriveMe:
            btnTitle = "已添加"
        case .friendInvitation:
            btnTitle = "同意"
            canClick = true
        case .selfRequestFriend:
            btnTitle = "等待验证"
        default:
          btnTitle =  ""
        }
        submitBtn.setTitle(btnTitle, for: .normal)
        submitBtn.setTitleColor(canClick ? UIColor.blue : UIColor.gray, for: .normal)
        submitBtn.isUserInteractionEnabled = canClick
        btnBlock = block
    }
    @IBAction func addFriend(_ sender: Any) {
        if let btnBlock = btnBlock {
            btnBlock()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
