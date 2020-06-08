//
//  Emitterable.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/21.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

protocol Emitterable {
    
}
extension Emitterable where Self: UIViewController{
    func start() {
        //创建发射器
        let emitter = CAEmitterLayer()
        //设置发射器的位置
        emitter.emitterPosition = CGPoint(x: view.bounds.width * 0.5, y: -60)
        //开启三维效果
        emitter.preservesDepth = true
        //创建粒子 并且设置粒子相关属性
        let cell = CAEmitterCell()
        //设置粒子速度
        cell.velocity = 150
        cell.velocityRange = 100
        //设置粒子的大小
        cell.scale = 0.7
        cell.scaleRange = 0.3
        //设置粒子方向
        cell.emissionLongitude = CGFloat(Double.pi / 2)
        cell.emissionRange = CGFloat(Double.pi / 2)
        //设置粒子的存活时间
        cell.lifetime = 6
        cell.lifetimeRange = 1.5
        //设置粒子旋转
        cell.spin = CGFloat(Double.pi / 2)
        cell.spinRange = CGFloat(Double.pi / 2)
        //设置粒子每秒弹出的个数
        cell.birthRate = 20
        //设置粒子展示的图片
        cell.contents = UIImage(named: "good6_30x30")?.cgImage
        //将粒子设置到发射器中
        emitter.emitterCells = [cell]
        //将发射器的layer添加到父layer中
        view.layer.addSublayer(emitter)
    }
    func stop() {
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}
