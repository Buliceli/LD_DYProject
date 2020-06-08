//
//  GiftViewModel.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import KakaJSON
import SwiftyJSON
class GiftViewModel: NSObject {
    lazy var giftlistData : [GiftPackage] = [GiftPackage]()

}
extension GiftViewModel{
    func loadGiftData(finishCallback: @escaping ()->()) {
        if self.giftlistData.count != 0 {
            finishCallback()
        }
        
        NetworkTools.requestData(.get, URLString: "http://qf.56.com/pay/v4/giftList.ios",parameters: ["type": 0,"page": 1,"rows": 150]) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataDict = resultDict["message"] as? [String : Any] else { return }
            for i in 0..<dataDict.count{
                guard let dict = dataDict["type\(i + 1)"] as? [String : Any] else {
                    continue
                }
                let everyModel: GiftPackage = model(from: dict, GiftPackage.self)
                self.giftlistData.append(everyModel)
            }
            self.giftlistData = self.giftlistData.filter({return $0.t != 0}).sorted(by: {return $0.t > $1.t})
            finishCallback()
        }
    }
}


/**
 let list = JSON(resultDict)["message"]["list"].arrayObject
           guard let models = list as? [[String:Any]] else {
               return
           }
           //anchorModels = modelArray(from: models, AnchorModel.self)
 */
