//
//  HomeViewModel.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/2.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import SwiftyJSON
import KakaJSON
class HomeViewMode {
    lazy var anchorModels = [AnchorModel]()
}
extension HomeViewMode {
    func loadHomeData(type: HomeType,index: Int,finishedCallback: @escaping ()->()) {
        guard let path: String = Bundle.main.path(forResource: "666", ofType: "json") else{
            return
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else { return }
        guard let jsonData:Any = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else{return}
       
        guard let resultDict = jsonData as? [String : Any] else{ return }
        let list = JSON(resultDict)["content"]["list"].arrayObject
        guard let models = list as? [[String:Any]] else {
            return
        }
        anchorModels = modelArray(from: models, AnchorModel.self)
        finishedCallback()
    }
}
