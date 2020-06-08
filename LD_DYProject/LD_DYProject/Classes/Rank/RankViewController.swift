//
//  RankViewController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/11.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
private let kEmoticonCell = "kEmoticonCell"
class RankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: 300)
        let titles = ["土豪","热门","专属","常见"]
        let style = LDTitleStyle()
        style.isShowBottomLine = true
        let layout = LDPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.cols = 4
        layout.rows = 2
        let pageCollectionView = LDPageCollectionView(frame: pageFrame, titles: titles, style: style, isTitleInTop: false, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.register(cell: UICollectionViewCell.self, identifier: kEmoticonCell)
        view.addSubview(pageCollectionView)
        loadGiftData {
            
        }
    }
}

extension RankViewController: LDPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: LDPageCollectionView) -> Int {
        return 4
    }
    func pageCollectionView(_ collectionView: LDPageCollectionView, numberOfItemInSection section: Int) -> Int {
        if section == 0 {
            return 20
        }else {
            return 14
        }
    }
    func pageCollectionView(_ pageCollectionView: LDPageCollectionView, _ collectionView: UICollectionView, cellForItem indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCell, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}


extension RankViewController{
    
    func loadGiftData(finishedCallback : @escaping () -> ()) {
           // http://qf.56.com/pay/v4/giftList.ios?type=0&page=1&rows=150
           
           NetworkTools.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios", parameters: ["type" : 0, "page" : 1, "rows" : 150], finishedCallback: { result in
               guard let resultDict = result as? [String : Any] else { return }
               
              print(resultDict)
               
               
               
               finishedCallback()
           })
       }
}
