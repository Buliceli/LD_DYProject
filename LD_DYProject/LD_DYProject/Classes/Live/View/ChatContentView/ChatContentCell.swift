//
//  ChatContentCell.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/4.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class ChatContentCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
    }

    
    
}
