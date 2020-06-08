//
//  LDSocket.swift
//  Client
//
//  Created by 李洞洞 on 2020/4/22.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit

protocol LDSocketDelegate: class {
    func socket(_ socket: LDSocket,joinRoom user: UserInfo)
    func socket(_ socket: LDSocket,leaveRoom user: UserInfo)
    func socket(_ socket: LDSocket,chatMsg : TextMessage)
    func socket(_ socket: LDSocket,giftMsg : GiftMessage)

}
class LDSocket {
    weak var delegate: LDSocketDelegate?
    fileprivate  var tcpClient:TCPClient
    lazy fileprivate var userInfo: UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "LDD"
        userInfo.level = 99
        return userInfo
    }()
    init(addr: String,port: Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }
}
extension LDSocket {
    func connectServer() -> Bool {
        return tcpClient.connect(timeout: 5).0
    }
    
    //客户端接收消息
    func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                guard let lMsg = self.tcpClient.read(4) else{
                    continue
                }
                //读取长度的data
                let headerData = Data(bytes: lMsg, count: 4)
                var length = 0
                (headerData as NSData).getBytes(&length, length: 4)
                print("服务端拿到的消息长度 - \(length)")
                //读取类型
                    guard let tMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: tMsg, count: 2)
                var type: Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                print("服务器拿到的消息的类型是 - \(type)")
                
                //根据长度 读取真实消息
                guard let msg = self.tcpClient.read(length) else{return}
                let data = Data(bytes: msg, count: length)
                DispatchQueue.main.async { //回到主线程
                    self.handleMsg(type: type, data: data)
                }
            }
        }
    }
    fileprivate func handleMsg(type: Int,data: Data){
        switch type {
        case 0,1:          //进入房间离开房间通知所有成员用代理
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            let chatMsg = try! TextMessage.parseFrom(data: data)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMsg: giftMsg)
         default:
            print("未知类型")
         }
    }
}
extension LDSocket {
    //发送进入房间的消息
    func sendJoinRoom() {
        let msgData = (try! userInfo.build()).data()
        sendMsg(data: msgData, type: 0)
    }
    //发送离开房间的消息
    func sendLeaveRoom() {
        let msgData = (try! userInfo.build()).data()
        sendMsg(data: msgData, type: 1)
    }
    //发送文本的消息
    func sendTextMsg(message: String) {
        let textMsg = TextMessage.Builder()
        textMsg.text = message
        textMsg.user = try! userInfo.build()
        let chatData = (try! textMsg.build()).data()
        sendMsg(data: chatData, type: 2)
    }
    //发送礼物的消息
    func sendGiftMsg(giftName: String,giftURL: String,giftCount: String) {
        let giftMsg = GiftMessage.Builder()
        giftMsg.giftname = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftCount = giftCount
        giftMsg.user = try! userInfo.build()
        let giftData = (try! giftMsg.build()).data()
        sendMsg(data: giftData, type: 3)
    }
    //发送心跳包
    func sendHeartBeat() {
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)
        
        sendMsg(data: heartData!, type: 100)
    }
    func sendMsg(data: Data,type: Int) {
        /*
         2.将消息长度写入data
         */
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        /*
         3.消息类型
         */
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)

        /*
         4.发送消息
         */
        let totalData = headerData + typeData + data

        tcpClient.send(data: totalData)
    }
}
