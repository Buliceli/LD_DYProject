//
//  LDNavController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/8.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class LDNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
     if #available(iOS 13.0, *) {
        let appearance = UITabBarAppearance()
        // 设置未被选中的颜色
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
           NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        // 设置被选中时的颜色
        appearance.stackedLayoutAppearance.selected.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : UIColor.orange]
        self.tabBarItem.standardAppearance = appearance
        
     } else {
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], for: .selected)
     }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
        {
        return .lightContent
    }
}
