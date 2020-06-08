//
//  EmoticonViewCell.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    var emoticon: Emoticon? {
        didSet{
            iconImageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
    
    
}
