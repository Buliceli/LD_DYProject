//
//  LDTitleView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/13.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

protocol LDTitleViewProtocol: class {
    func titleView(_ titleView: LDTitleView,selectedIndex: Int)
}
class LDTitleView: UIView {

    //MARK: -对外属性
    weak var delegate: LDTitleViewProtocol?
    //MARK: -定义属性
    fileprivate  var titles: [String]
    fileprivate  var style: LDTitleStyle
    fileprivate  var currentIndex: Int = 0
    
    //MARK: -存储属性
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    //MARK: -控件属性
    fileprivate lazy var scrollView: UIScrollView = {
        let scorllView = UIScrollView()
        scorllView.frame = self.bounds
        scorllView.showsHorizontalScrollIndicator = false
        scorllView.scrollsToTop = false
        return scorllView
    }()
    fileprivate lazy var splitLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        let h: CGFloat = 0.5
        view.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return view
    }()
    fileprivate lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.bottomLineColor
        return view
    }()
    fileprivate lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = self.style.converBgColor
        view.alpha = 0.7
        return view
    }()
    //MARK: -计算属性
    fileprivate lazy var normalColorRGB: (r: CGFloat,g: CGFloat,b: CGFloat) = self.getRGBWithColor(self.style.normalColor)
    fileprivate lazy var selectedColorRGB: (r: CGFloat,g: CGFloat,b: CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    //MARK: - 自定义构造函数
    init(frame: CGRect,titles: [String], style: LDTitleStyle) {
        self.titles = titles
        self.style  = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - 设置UI界面内容
extension LDTitleView {
   fileprivate func setupUI() {
    //添加ScrollView
    addSubview(scrollView)
    //添加底部分割线
    addSubview(splitLineView)
    //设置所有的标题Label
    setupTitleLabels()
    //设置Label的位置
    setupTitlesPosition()
    //设置底部的滑动条
    if style.isShowBottomLine {
        setupBottomLine()
    }
    //设置遮盖的View
    if style.isShowCover {
        setupCoverView()
    }
    }
    
    fileprivate func setupTitleLabels() {
        for (index,title) in titles.enumerated() {
            let label: UILabel = UILabel()
            label.tag = index
            label.text = title
            label.textColor = index == 0 ? self.style.selectedColor : self.style.normalColor
            label.font = self.style.font
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            
            titleLabels.append(label)
            self.scrollView.addSubview(label)
        }
    }
    fileprivate func setupTitlesPosition() {
        var titleX: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        let titleH: CGFloat = frame.height
        let count = titles.count
        
        for (index,label) in titleLabels.enumerated() {
            if style.isScoreEnable {
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: style.font], context: nil)
                titleW = rect.width
                if index == 0 {
                    titleX = style.titleMargin * 0.5
                }else{
                    let preLabel: UILabel = titleLabels[index - 1]
                    titleX = preLabel.frame.maxX + style.titleMargin
                    
                }
            }else{
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            //放大的代码
            if index == 0 {
                let scale = style.isNeedScale ? style.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        if style.isScoreEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
    }
    fileprivate func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.origin.y = bounds.height - style.bottomLineH
    }
    fileprivate func setupCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel: UILabel = titleLabels.first!
        var coverW = firstLabel.frame.width
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
        if style.isScoreEnable {
            coverX -= style.coverMargin
            coverW += style.coverMargin * 2
        }
        
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}

//MARK: -事件处理
extension LDTitleView {
    @objc fileprivate func titleLabelClick(_ tap: UITapGestureRecognizer){
        //获取当前的Label
        guard let currentLabel: UILabel = tap.view as? UILabel else{ return }
        //如果点击的同一个Label return
        if currentLabel.tag == currentIndex { return }
        //获取之前的Label
        let oldLabel: UILabel = titleLabels[currentIndex]
        //切换文字颜色
        currentLabel.textColor = style.selectedColor
        oldLabel.textColor     = style.normalColor
        //更新currentIndex
        currentIndex = currentLabel.tag
        delegate?.titleView(self, selectedIndex: currentIndex)
        //居中显示
        contentViewDidEndScroll()
        
        //调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15) {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.size.width
            }
        }
        //调整缩放比例
        if style.isNeedScale {
            oldLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
        //移动遮盖
        if style.isShowCover {
            let coverX = style.isScoreEnable ? (currentLabel.frame.origin.x - style.coverMargin) : currentLabel.frame.origin.x
            let coverW = style.isScoreEnable ? (currentLabel.frame.width + style.coverMargin * 2) : currentLabel.frame.width
            UIView.animate(withDuration: 0.15) {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            }
        }
    }
}
//MARK: -获取RGB值
extension LDTitleView {
    fileprivate func getRGBWithColor(_ color: UIColor) ->(CGFloat,CGFloat,CGFloat){
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给Title赋值颜色")
        }
        return (components[0] * 255,components[1] * 255,components[2] * 255)
    }
}
//MARK: -对外暴露的方法
extension LDTitleView {
    func setTitleWithProgress(_ progress: CGFloat, sourceIndex: Int,targetIndex: Int){
        //去除sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        //颜色变化
        //取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0,selectedColorRGB.1 - normalColorRGB.1,selectedColorRGB.2 - normalColorRGB.2)
        //变化sourceLabel
        sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g:selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
        //变化targetLabel
        targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
        //记录最新的index
        currentIndex = targetIndex
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        //计算滚动的范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        //放大比例
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        //计算cover的滚动
        if style.isShowCover {
            coverView.frame.size.width = style.isScoreEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress):(sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScoreEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress):(sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }
     func contentViewDidEndScroll(){
        //不需要滚动的情况 不需要调整中间位置
        guard style.isScoreEnable else {
            return
        }
        //获取目标的Label
        let targetLabel = titleLabels[currentIndex]
        //计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        //滚动UIScrollView
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}
