//
//  LDGiftDigitLabel.swift
//  礼物动画展示
//
//  Created by 李洞洞 on 2020/5/30.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

class LDGiftDigitLabel: UILabel {

    override func drawText(in rect: CGRect) {
        // 1.获取上下文
       let context = UIGraphicsGetCurrentContext()
       
       // 2.给上下文线段设置一个宽度, 通过该宽度画出文本
       context?.setLineWidth(5)
       context?.setLineJoin(.round)
       context?.setTextDrawingMode(.stroke)
       textColor = UIColor.orange
       super.drawText(in: rect)
       
       context?.setTextDrawingMode(.fill)
       textColor = UIColor.white
       super.drawText(in: rect)
    }
    
    func showDigitAnimation(_ complection: @escaping ()->()){
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 3.0, y: 3.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
            
        }, completion: { (isFinish) in
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }) { (isFinished) in
                complection()
            }
        })
    }
}
