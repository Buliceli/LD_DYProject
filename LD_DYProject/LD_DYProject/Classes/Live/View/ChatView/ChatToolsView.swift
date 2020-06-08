//
//  ChatToolsView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
protocol ChatToolsViewDelegate : class {
    func chatToolsView(toolView : ChatToolsView, message : String)
}
class ChatToolsView: UIView,NibLoadable {
    weak var delegate : ChatToolsViewDelegate?
    fileprivate lazy var emoticonBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    fileprivate lazy var emoticonView: EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 280))
    
    @IBOutlet weak var inputTextFiled: UITextField!
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    @IBAction func textFiledDidEdit(_ sender: UITextField) {
        sendMsgBtn.isEnabled = sender.text?.count != 0
    }
    
    @IBAction func sendBtnClick(_ sender: UIButton) {
        // 1.获取内容
        let message = inputTextFiled.text!
        
        // 2.清空内容
        inputTextFiled.text = ""
        sender.isEnabled = false
        delegate?.chatToolsView(toolView: self, message: message)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sendMsgBtn.frame = CGRect(x: kScreenW - 50, y: 0, width: 50, height: 44)
        inputTextFiled.frame = CGRect(x: 0, y: 0, width: kScreenW - 50, height: 44)
        setupUI()
        
    }
}

//MARK: - 设置UI
extension ChatToolsView{
    fileprivate func setupUI(){
        self.backgroundColor = .purple
        emoticonBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        emoticonBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        emoticonBtn.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        tempView.addSubview(emoticonBtn)
        emoticonBtn.center = tempView.center
        
        inputTextFiled.rightView = tempView
        inputTextFiled.rightViewMode = .always
        inputTextFiled.allowsEditingTextAttributes = true
        
        emoticonView.emoticonClickCallback = {[weak self] emoticon in
            if emoticon.emoticonName == "delete-n" {
                self?.inputTextFiled.deleteBackward()
                return
            }
            
            //获取光标位置
            guard let range = self?.inputTextFiled.selectedTextRange else {
                return
            }
            self?.inputTextFiled.replace(range, withText: emoticon.emoticonName)
        }
    }
}


//MARK: - 事件处理
extension ChatToolsView{
    @objc fileprivate func emoticonBtnClick(_ btn: UIButton){
        btn.isSelected = !btn.isSelected
        
        // 切换键盘
        let range = inputTextFiled.selectedTextRange
        inputTextFiled.resignFirstResponder()
        inputTextFiled.inputView = inputTextFiled.inputView == nil ? emoticonView : nil
        inputTextFiled.becomeFirstResponder()
        inputTextFiled.selectedTextRange = range
    }
}
