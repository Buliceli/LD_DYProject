//
//  ProfileViewController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/11.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let demoView = DemoView.loadFromNib()
        demoView.center = view.center
        view.addSubview(demoView)
    }

}


