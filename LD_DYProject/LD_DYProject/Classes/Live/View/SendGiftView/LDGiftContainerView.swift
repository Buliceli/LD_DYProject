//
//  LDGiftContainerView.swift
//  礼物动画展示
//
//  Created by 李洞洞 on 2020/5/30.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10
class LDGiftContainerView: UIView {

    // MARK: 定义属性
      fileprivate lazy var channelViews : [LDGiftChannelView] = [LDGiftChannelView]()
      fileprivate lazy var cacheGiftModels : [LDGiftModel] = [LDGiftModel]()
    // MARK: 构造函数
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
// MARK:- 设置UI界面
extension LDGiftContainerView {
    fileprivate func setupUI() {
        // 1.根据当前的渠道数，创建HYGiftChannelView
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0..<kChannelCount {
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            let channelView = LDGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
            
            channelView.complectionCallback = { channelView in
                //1. 去除缓存中的模型
                guard self.cacheGiftModels.count != 0 else {
                    return
                }
                //2.取出缓存中的第一个模型
                let firstGiftModel = self.cacheGiftModels.first!
                self.cacheGiftModels.removeFirst()
                
                for i in (0..<self.cacheGiftModels.count).reversed() {
                    let giftModel = self.cacheGiftModels[i]
                    if giftModel.isEqual(firstGiftModel) {
                        channelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
                //3.让闲置的channelView执行动画
                channelView.giftModel = firstGiftModel
                
            }
        }
    }
}


extension LDGiftContainerView{
    func showGiftModel(_ giftModel: LDGiftModel) {
        //判断正在忙的chanelView和赠送的新礼物的(userName/giftName)是否相等
        if let channelView = checkUsingChaneView(giftModel) {
            channelView.addOnceToCache()
            return
        }
        //判断有没有闲置的ChaneView
        if let channelView = checkIdleChannelView() {
            channelView.giftModel = giftModel
            return
        }
        //将数据放入缓存中
        cacheGiftModels.append(giftModel)
    }
    private func checkUsingChaneView(_ giftModel: LDGiftModel) -> LDGiftChannelView?{
        for channelView in channelViews {
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating {
                return channelView
            }
        }
        return nil
    }
    private func checkIdleChannelView()->LDGiftChannelView?{
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        return nil
    }
}























