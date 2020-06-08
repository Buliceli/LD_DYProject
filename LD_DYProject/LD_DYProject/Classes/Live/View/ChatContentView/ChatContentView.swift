//
//  ChatContentView.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/5/4.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
private let kChatContentCell = "kChatContentCell"

class ChatContentView: UIView,NibLoadable {
    fileprivate lazy var messages : [NSAttributedString] = [NSAttributedString]()
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "ChatContentCell", bundle: nil), forCellReuseIdentifier: kChatContentCell)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        self.backgroundColor = .clear
    }
    func insertMsg(_ message: NSAttributedString) {
        messages.append(message)
        tableView.reloadData()
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
               tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
extension ChatContentView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatContentCell, for: indexPath) as! ChatContentCell
        cell.label.attributedText = messages[indexPath.row]
        return cell
    }
}
