//
//  EmoticonPackage.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class EmoticonPackage {

    lazy var emoticons: [Emoticon] = [Emoticon]()
    init(plistName: String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else{return}
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else{return}
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
}
