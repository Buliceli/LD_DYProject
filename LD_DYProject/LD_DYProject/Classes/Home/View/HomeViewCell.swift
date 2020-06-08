//
//  HomeViewCell.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import Kingfisher
class HomeViewCell: UICollectionViewCell {

 //MARK: - 控件属性
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlinePeopleLabel: UIButton!
    
    var anchorModel: AnchorModel?{
        didSet{
            albumImageView.kf.setImage(with: URL(string: anchorModel?.anchor_pic.first ?? ""))
            nickNameLabel.text = anchorModel!.anchor_name
            onlinePeopleLabel.setTitle("\(anchorModel?.online ?? 0)", for: .normal)
        }
    }
    
}
