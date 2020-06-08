//
//  GiftPackage.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import KakaJSON
struct GiftPackage: Convertible {
    var t : Int = 0
    var title : String = ""
    var list : [GiftModel] = [GiftModel]()
}
