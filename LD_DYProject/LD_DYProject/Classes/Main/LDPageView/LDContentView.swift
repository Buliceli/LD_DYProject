//
//  LDContentView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/13.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

protocol LDContentViewProtocl: class {
    func contentView(_ contentView: LDContentView,progress: CGFloat,sourceIndex: Int,targetIndex: Int)
    func contentViewEndScroll(_ contentView: LDContentView)
}

private let kContentCellID = "kContentCellID"
class LDContentView: UIView {
    //MARK: -对外属性
    weak var delegate: LDContentViewProtocl?
   //MARK: -定义属性
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidScrollDelegate: Bool = false
    
   //MARK: -控件属性
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        return collectionView
    }()
   //MARK: -自定义构造函数
    init(frame: CGRect,childVcs: [UIViewController],parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: -设置界面内容
extension LDContentView {
    fileprivate func setupUI(){
        //将所有控制器添加到父控制器中
        for vc in childVcs {
            parentVc.addChild(vc)
        }
        //添加collectionView
        addSubview(collectionView)
    }
}
//MARK: -设置CollectionView的数据源
extension LDContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        //设置cell内容
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item];
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        cell.backgroundColor = UIColor.randomColor()
        return cell
        
    }
}
//MARK: -设置CollectionView的代理
extension LDContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //判断是否是点击事件
        if isForbidScrollDelegate {
            return
        }
        //定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        //判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { //左滑
            //计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //计算targerIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{                             //右滑
            //计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            //计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            //计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
     //将progress/sourceIndex/targetIndex传递给titleView
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll(self)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.contentViewEndScroll(self)
        }
    }
}
//MARK: -对外披露的方法
extension LDContentView {
    func setCurrentIndex(_ currentIndex: Int) {
        isForbidScrollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
    }
}
