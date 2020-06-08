//
//  EmoticonViewModel.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class EmoticonViewModel {

    static let shareInstance: EmoticonViewModel = EmoticonViewModel()
    lazy var packages: [EmoticonPackage] = [EmoticonPackage]()
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}
