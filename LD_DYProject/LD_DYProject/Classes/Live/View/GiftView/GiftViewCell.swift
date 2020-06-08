//
//  GiftViewCell.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/4.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import Kingfisher
class GiftViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 5
        selectedView.layer.masksToBounds = true
        selectedView.layer.borderWidth = 1
        selectedView.layer.borderColor = UIColor.orange.cgColor
        selectedView.backgroundColor = UIColor.black
        
        selectedBackgroundView = selectedView
    }
    
    var giftModel: GiftModel?{
        didSet{
            iconImageView.kf.setImage(with: URL(string: giftModel?.img2 ?? ""))
            subjectLabel.text = giftModel?.subject
            priceLabel.text = "\(giftModel?.coin ?? 0)"
        }
    }
    

}
