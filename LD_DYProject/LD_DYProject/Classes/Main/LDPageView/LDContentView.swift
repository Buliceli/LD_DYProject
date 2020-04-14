//
//  LDContentView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/13.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class LDContentView: UIView {

   //MARK: -自定义构造函数
    init(frame: CGRect,childVcs: [UIViewController],parentVc: UIViewController) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
