//
//  MainViewController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/11.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVc("Home")
        addChildVc("Rank")
        addChildVc("Discover")
        addChildVc("Profile")
    }
    
    fileprivate func addChildVc(_ storyboardName: String) {
        let childVc = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
        
        addChild(childVc)
    }

}
