//
//  AnchorViewController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/21.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import Alamofire
private let kEdgeMargin: CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"
class AnchorViewController: UIViewController {

    //MARK: - 对外属性
    var homeType: HomeType!
    //MARK: - 定义属性
    fileprivate lazy var homeVM: HomeViewMode = HomeViewMode()
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        homeVM.loadHomeData(type: homeType, index: 0) {
            self.collectionView.reloadData()
        }
    }


}
//MARK: -collectionView的数据源&代理
extension AnchorViewController: UICollectionViewDataSource,WaterfallLayoutDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeViewCell
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let roomVc = RoomViewController()
        roomVc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(roomVc, animated: true)
        
    }
    func waterfallLayout(_ layout: WaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return kScreenW * 0.5
    }
    
    
}

