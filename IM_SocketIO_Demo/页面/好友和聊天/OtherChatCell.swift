//
//  OtherChatCell.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/18.
//  Copyright © 2018年 Wang. All rights reserved.
//

import UIKit

class OtherChatCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var headImageV: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(with model: SocketMessage) {
        nameLbl.text = model.from
        if let body = model.body as? SocketTextBody {
            messageLbl.text = body.text
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
