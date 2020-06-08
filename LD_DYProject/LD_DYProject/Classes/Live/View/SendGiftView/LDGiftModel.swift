//
//  LDGiftModel.swift
//  礼物动画展示
//
//  Created by 李洞洞 on 2020/5/30.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class LDGiftModel: NSObject {
    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    init(senderName: String,senderURL: String,giftName: String,giftURL: String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? LDGiftModel else{
            return false
        }
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        return true
    }
}
