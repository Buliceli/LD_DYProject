//
//  LDGiftChannelView.swift
//  礼物动画展示
//
//  Created by 李洞洞 on 2020/5/30.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

enum LDGiftChannelViewState {
    case idle //闲置
    case animationg //执行动画中
    case willEnd    //将要结束
    case endAnimating //执行结束动画中
}
class LDGiftChannelView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var giftDescLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var digitLabel: LDGiftDigitLabel!
   
    fileprivate var cacheNumber : Int = 0
    fileprivate var currentNumber: Int = 0
    var complectionCallback: ((LDGiftChannelView)->Void)?
    
    var state: LDGiftChannelViewState = .idle
    var giftModel: LDGiftModel? {
        didSet{
            //校验模型
            guard let giftModel = giftModel else {
                return
            }
            //给控件设置信息
            iconImageView.image = UIImage(named: giftModel.senderURL)
            senderLabel.text = giftModel.senderName
            giftDescLabel.text = "送出礼物：【\(giftModel.giftName)】"
            giftImageView.image = UIImage(named: giftModel.giftURL)
            //将ChanelView弹出
            state = .animationg
            performAnimation()
        }
    }
}
// MARK:- 设置UI界面
extension LDGiftChannelView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.layer.cornerRadius = frame.height * 0.5
        iconImageView.layer.cornerRadius = frame.height * 0.5
        bgView.layer.masksToBounds = true
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.green.cgColor
    }
}
//MARK: -执行动画的代码
extension LDGiftChannelView{
    fileprivate func performAnimation(){
        digitLabel.alpha = 1.0
        digitLabel.text = "x1"
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.frame.origin.x = 0
        }) { (isFinished) in
            self.performDigitAnimation()
        }
    }
    fileprivate func performDigitAnimation(){
        currentNumber += 1
        digitLabel.text = "x\(currentNumber)"
        digitLabel.showDigitAnimation {
            
        if self.cacheNumber > 0 {
            self.cacheNumber -= 1
            self.performDigitAnimation()
        }else{
            self.state = .willEnd
            self.perform(#selector(self.performEndAnimation), with: nil, afterDelay: 3.0)
        }
        }
    }
    @objc fileprivate func performEndAnimation(){
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.origin.x = UIScreen.main.bounds.width
            self.alpha = 0.0
        }) { (isFinished) in
            self.currentNumber = 0
            self.cacheNumber = 0
            self.giftModel = nil
            self.frame.origin.x = -self.frame.width
            self.state = .idle
            self.digitLabel.alpha = 0.0
            if let complectionCallback = self.complectionCallback {
                complectionCallback(self)
            }
        }
    }
}
//MARK: -对外提供的函数
extension LDGiftChannelView{
    class func loadFromNib() -> LDGiftChannelView{
        return Bundle.main.loadNibNamed("LDGiftChannelView", owner: nil, options: nil)?.first as! LDGiftChannelView
    }
    
    func addOnceToCache() {
        if state == .willEnd {
            performDigitAnimation()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
        }else{
            cacheNumber += 1
        }
    }
}





































