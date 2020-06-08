//
//  GiftListView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/4.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
private let kGiftCellID = "kGiftCellID"
protocol GiftListViewDelegate : class {
    func giftListView(giftView : GiftListView, giftModel : GiftModel)
}
class GiftListView: UIView,NibLoadable {
    weak var delegate : GiftListViewDelegate?
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var sendGiftBtn: UIButton!
    @IBAction func sendGiftBtnClick(_ sender: UIButton) {
        let package = giftVM.giftlistData[currentIndexPath!.section]
        let giftModel = package.list[currentIndexPath!.item]
        delegate?.giftListView(giftView: self, giftModel: giftModel)
    }
    fileprivate var pageCollectionView : LDPageCollectionView!
    fileprivate var currentIndexPath : IndexPath?
    fileprivate var giftVM : GiftViewModel = GiftViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        giftVM.loadGiftData {
            self.pageCollectionView.reloadData()
        }
    }
}
//MARK: -设置UI
extension GiftListView{
    fileprivate func setupUI(){
        setupGiftView()
    }
    fileprivate func setupGiftView(){
        let style = LDTitleStyle()
        style.isScoreEnable = false
        style.isShowBottomLine = true
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        
        let layout = LDPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 4
        layout.rows = 2
        
        var pageViewFrame = giftView.bounds
        pageViewFrame.size.width = kScreenW
        pageCollectionView = LDPageCollectionView(frame: pageViewFrame, titles: ["热门", "高级", "豪华", "专属"], style: style, isTitleInTop: true, layout : layout)
        giftView.addSubview(pageCollectionView)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.register(nib: UINib(nibName: "GiftViewCell", bundle: nil), identifier: kGiftCellID)
        
        //pageCollectionView.backgroundColor = .darkGray
    }
}

// MARK:- 数据设置
extension GiftListView : LDPageCollectionViewDataSource, LDPageCollectionViewDelegate {
    func numberOfSections(in pageCollectionView: LDPageCollectionView) -> Int {
        return giftVM.giftlistData.count
    }
    func pageCollectionView(_ collectionView: LDPageCollectionView, numberOfItemInSection section: Int) -> Int {
        let package = giftVM.giftlistData[section]
        return package.list.count
    }
    func pageCollectionView(_ pageCollectionView: LDPageCollectionView, _ collectionView: UICollectionView, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftCellID, for: indexPath) as! GiftViewCell
        let package = giftVM.giftlistData[indexPath.section]
        cell.giftModel = package.list[indexPath.item]
        //cell.backgroundColor = .orange
        return cell
    }
    func pageCollectionView(_ pageCollectionView: LDPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        sendGiftBtn.isEnabled = true
        currentIndexPath = indexPath
    }
}
