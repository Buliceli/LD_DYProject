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
    
    fileprivate var titleView: LDTitleView?
    fileprivate var contentView: LDContentView?

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
    let titleH: CGFloat = 44
    let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
    titleView = LDTitleView(frame: titleFrame, titles: self.titles, style: self.style)
    titleView?.delegate = self
    addSubview(titleView!)
    
    let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
    contentView = LDContentView(frame: contentFrame, childVcs: self.childVcs, parentVc: self.parentVc)
    contentView!.delegate = self
    addSubview(contentView!)
  }
}

//MARK: -设置LDContentView的代理
extension LDPageView: LDContentViewProtocl {
    func contentView(_ contentView: LDContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView?.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    func contentViewEndScroll(_ contentView: LDContentView) {
        titleView?.contentViewDidEndScroll()
    }
}
//MARK: -设置LDTitleView的代理
extension LDPageView: LDTitleViewProtocol {
    func titleView(_ titleView: LDTitleView,selectedIndex: Int){
        contentView?.setCurrentIndex(selectedIndex)
    }
}
