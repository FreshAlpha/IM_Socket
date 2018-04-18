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
    func configureCell(with model: SocketSystemMessage, block: (()->())?) {
        nameLbl.text = model.fromID
        msgLbl.text = model.msg
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
