//
//  EmoticonView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
private let kEmoticonCellID = "kEmoticonCellID"
class EmoticonView: UIView {

    var emoticonClickCallback:  ((Emoticon)-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmoticonView{
    fileprivate func setupUI(){
        let style = LDTitleStyle()
        style.isShowBottomLine = true
        let layout = LDPageCollectionViewLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = LDPageCollectionView(frame: bounds, titles: ["普通","粉丝专属"], style: style, isTitleInTop: false, layout: layout)
        addSubview(pageCollectionView)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate   = self
        pageCollectionView.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil), identifier: kEmoticonCellID)
        
        
        
    }
}

extension EmoticonView: LDPageCollectionViewDataSource{
    func numberOfSections(in pageCollectionView: LDPageCollectionView) -> Int {
        EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ collectionView: LDPageCollectionView, numberOfItemInSection section: Int) -> Int {
        EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    
    func pageCollectionView(_ pageCollectionView: LDPageCollectionView, _ collectionView: UICollectionView, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
}
extension EmoticonView: LDPageCollectionViewDelegate{
    func pageCollectionView(_ pageCollectionView: LDPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        if let emoticonClickCallback = emoticonClickCallback {
            emoticonClickCallback(emoticon)
        }
    }
}
