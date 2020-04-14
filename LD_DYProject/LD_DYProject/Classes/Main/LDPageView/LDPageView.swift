//
//  LDPageView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/13.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class LDPageView: UIView {

    //MARK: -定义属性
    fileprivate var titles: [String]
    fileprivate var style: LDTitleStyle
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    
    //MARK: -自定义构造函数
    init(frame: CGRect,titles:[String],style: LDTitleStyle,childVcs: [UIViewController],parentVc:UIViewController) {
        self.titles = titles
        self.style  = style
        self.childVcs = childVcs
        self.parentVc = parentVc
        if #available(iOS 11, *) {
        }else{
          self.parentVc.automaticallyAdjustsScrollViewInsets = false
        }
        assert(titles.count == childVcs.count,"标题&控制器个数不相同!")
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 设置界面内容
extension LDPageView {
   fileprivate func setupUI() {
    self.backgroundColor = UIColor.cyan
    let titleH: CGFloat = 44
    let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
    let titleView = LDTitleView(frame: titleFrame, titles: self.titles, style: self.style)
    titleView.backgroundColor = UIColor.red
    addSubview(titleView)
    
    let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
    let contentView = LDContentView(frame: contentFrame, childVcs: self.childVcs, parentVc: self.parentVc)
    contentView.backgroundColor = UIColor.purple
    addSubview(contentView)
  }
}
