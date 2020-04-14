//
//  LDTitleView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/13.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class LDTitleView: UIView {

    //MARK: - 自定义构造函数
    init(frame: CGRect,titles: [String], style: LDTitleStyle) {
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 设置UI界面内容
extension LDTitleView {
   fileprivate func setupUI() {
        
    }
}
