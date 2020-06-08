//
//  RoomViewController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/3.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5
private let kChatContentViewHeight : CGFloat = 200
class RoomViewController: UIViewController,Emitterable {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var giftBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var lastBtn: UIButton!
    fileprivate lazy var chatToolsView: ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var chatContentView : ChatContentView = ChatContentView.loadFromNib()
    fileprivate lazy var giftContentView: LDGiftContainerView = LDGiftContainerView()
    fileprivate lazy var socket: LDSocket = LDSocket(addr: "192.168.0.126", port: 7777)
    fileprivate var heartBeatTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置UI界面
        setupUI()
        // 2.监听键盘的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //3.连接聊天服务器
        if socket.connectServer() {
            print("连接成功")
            socket.startReadMsg()
            addHeartBeatTimer()
            socket.sendJoinRoom()
            socket.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: - 设置UI
extension RoomViewController {
    fileprivate func setupUI(){
        setupBlurView()
        setupBottomView()
        setupSendGiftView()
    }
    fileprivate func setupBlurView(){
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        blurView.frame = bgImageView.bounds
        //blurView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        bgImageView.isUserInteractionEnabled = true
        blurView.isUserInteractionEnabled = true
        bgImageView.addSubview(blurView)
        
    }
    fileprivate func setupBottomView(){
        // 0.设置Chat内容的View
        chatContentView.frame = CGRect(x: 0, y: view.bounds.height - 44 - kChatContentViewHeight, width: view.bounds.width, height: kChatContentViewHeight)
        chatContentView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(chatContentView)
        
        // 1.设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        //2.设置giftListView
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
        
    }
    fileprivate func setupSendGiftView(){
        giftContentView.frame = CGRect(x: 0, y: kScreenH - 55 - 90 - 300, width: 250, height: 90)
        giftContentView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContentView)
    }
}
//MARK: - 事件监听
extension RoomViewController{
    
    @IBAction func exitBtnClick(){
        navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextFiled.resignFirstResponder()
        UIView.animate(withDuration: 0.25, animations: {
          self.giftListView.frame.origin.y = kScreenH
        })
//        let gift1 = LDGiftModel(senderName: "LDD", senderURL: "icon1", giftName: "火箭", giftURL: "prop_f")
//        giftContentView.showGiftModel(gift1)
    }
    @IBAction func bottomMenuClick(_ sender: UIButton){
        print("--------------\(sender.tag)")
        switch sender.tag {
        case 1:
            print("消息")
            //chatToolsView.inputTextFiled.becomeFirstResponder()
        case 2:
            print("分享")
        case 3:
            print("礼物")
            UIView.animate(withDuration: 0.25, animations: {
                self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })

        case 4:
            print("更多")

        case 5:
            print("...")
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()

        default:
            fatalError("未处理按钮")
        }
    }
}
//MARK: - 监听键盘的弹出
extension RoomViewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        UIView.animate(withDuration: duration) {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            //self.chatToolsView.frame.origin.y = endY
            self.chatToolsView.frame = CGRect(x: 0, y: endY, width: kScreenW, height: kChatToolsViewHeight)
            let contentEndY = inputViewY == (kScreenH - kChatToolsViewHeight) ? (kScreenH - kChatContentViewHeight - 44) : endY - kChatContentViewHeight
            self.chatContentView.frame = CGRect(x: 0, y: contentEndY, width: kScreenW, height: kChatContentViewHeight)
        }
    }
}
//MARK: -监听用户输入的内容
extension RoomViewController: ChatToolsViewDelegate,GiftListViewDelegate{
    func giftListView(giftView: GiftListView, giftModel: GiftModel) {
        socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: "1")
    }
    
    func chatToolsView(toolView: ChatToolsView, message: String) {
        socket.sendTextMsg(message: message)

    }
}
//MARK: - 给服务器发送心跳包
extension RoomViewController{
    fileprivate func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: .common)
    }
    
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}
//MARK: - 接收聊天服务器返回的消息
extension RoomViewController: LDSocketDelegate{
    func socket(_ socket: LDSocket, joinRoom user: UserInfo) {
        print("\(String(describing: user.name)) 进入房间")
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, true))
    }
    
    func socket(_ socket: LDSocket, leaveRoom user: UserInfo) {
        print("\(String(describing: user.name)) 离开房间")
        chatContentView.insertMsg(AttrStringGenerator.generateJoinLeaveRoom(user.name, false))
    }
    
    func socket(_ socket: LDSocket, chatMsg: TextMessage) {
        print("\(String(describing: chatMsg.user.name)): \(String(describing: chatMsg.text))")
        // 1.通过富文本生成器, 生产需要的富文本
        let chatMsgMAttr = AttrStringGenerator.generateTextMessage(chatMsg.user.name, chatMsg.text)
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(chatMsgMAttr)
    }
    
    func socket(_ socket: LDSocket, giftMsg: GiftMessage) {
        print("\(String(describing: giftMsg.user.name)) 赠送 \(String(describing: giftMsg.giftname)) \(String(describing: giftMsg.giftUrl))")
        // 1.通过富文本生成器, 生产需要的富文本
        let giftMsgAttr = AttrStringGenerator.generateGiftMessage(giftMsg.giftname, giftMsg.giftUrl, giftMsg.user.name)
        // 2.将文本的属性字符串插入到内容View中
        chatContentView.insertMsg(giftMsgAttr)
    }
    
    
}
