//
//  LDPageCollectionView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/21.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

protocol LDPageCollectionViewDataSource: class {
    func numberOfSections(in pageCollectionView: LDPageCollectionView) -> Int
    func pageCollectionView(_ collectionView: LDPageCollectionView, numberOfItemInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: LDPageCollectionView, _ collectionView: UICollectionView, cellForItem indexPath: IndexPath) -> UICollectionViewCell
}

class LDPageCollectionView: UIView {

    weak var dataSource: LDPageCollectionViewDataSource?
    //MARK: -定义属性
    fileprivate var titles: [String]
    fileprivate var style: LDTitleStyle
    fileprivate var layout: LDPageCollectionViewLayout
    fileprivate var isTitleInTop: Bool
    fileprivate var titleView: LDTitleView?
    fileprivate var pageContrl: UIPageControl?
    fileprivate var collectionView: UICollectionView?
    fileprivate var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    init(frame: CGRect,titles: [String],style: LDTitleStyle,isTitleInTop: Bool,layout: LDPageCollectionViewLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        self.isTitleInTop = isTitleInTop
        super.init(frame: frame)
        sertupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: -设置UI界面
extension LDPageCollectionView{
    fileprivate func sertupUI()  {
        //创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = LDTitleView(frame: titleFrame, titles: titles, style: style)
        titleView?.delegate = self
        addSubview(titleView!)
        titleView?.backgroundColor = UIColor.randomColor()
        
        //创建UIPageControl
        let pageControlHeight: CGFloat = 20
        let pageControlY = isTitleInTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageContrl = UIPageControl(frame: pageControlFrame)
        pageContrl?.numberOfPages = 4
        pageContrl?.isEnabled = false
        addSubview(pageContrl!)
        pageContrl?.backgroundColor = UIColor.randomColor()
        
        //创建UICollectionView
        let collectionViewY = isTitleInTop ? (style.titleHeight) : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        addSubview(collectionView!)
        collectionView?.backgroundColor = UIColor.randomColor()
    }
}
//MARK: - LDTitleViewProtocol
extension LDPageCollectionView: LDTitleViewProtocol {
    func titleView(_ titleView: LDTitleView, selectedIndex: Int) {
        let indexPath = IndexPath(item: 0, section: selectedIndex)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView?.contentOffset.x -= layout.sectionInset.left
        scrollViewEndScroll()
    }
}
//MARK: - UICollectionViewDataSource
extension LDPageCollectionView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemInSection: section) ?? 0
        if section == 0 {
            pageContrl?.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItem: indexPath)
    }
}
//MARK: - UICollectionViewDelegate
extension LDPageCollectionView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    fileprivate func scrollViewEndScroll(){
        // 取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView!.contentOffset.x, y: layout.sectionInset.top + 1)
        
        guard let indexPath = collectionView?.indexPathForItem(at: point) else {
            return
        }
        //判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            //修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemInSection: indexPath.section) ?? 0
            pageContrl?.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            //设置titleView位置
            titleView?.setTitleWithProgress(1, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            //记录最新的indexPath
            sourceIndexPath = indexPath
        }
        //根据indexPath设置pageControl
        pageContrl?.currentPage = indexPath.item / (layout.cols * layout.rows)
        
    }
}
//MARK: -对外暴露的方法
extension LDPageCollectionView {
    func register(cell: AnyClass?,identifier: String){
        collectionView?.register(cell, forCellWithReuseIdentifier: identifier)
    }
    func register(nib: UINib,identifier: String){
        collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
    }
}
