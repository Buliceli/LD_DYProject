//
//  Const.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/21.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

let kNavigationBarH : CGFloat = UIDevice.current.isiPhoneXorLater() ? 88 : 64
let kTabbarH: CGFloat = UIDevice.current.isiPhoneXorLater() ? 83 : 49

let kStatusBarH : CGFloat = 20

extension UIDevice {
    func isiPhoneXorLater() -> Bool {
        if kScreenH == 2436 || kScreenH == 1792 || kScreenH == 2688 || kScreenH == 1624 {
            return true
        }else{
            return false
        }
    }
}



