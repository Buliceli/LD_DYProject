//
//  HomeViewController.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/11.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import KakaJSON
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}
//MARK: -设置UI界面内容
extension HomeViewController {
    fileprivate func setupUI(){
        setupNavigationBar()
        setupContentView()
    }
    fileprivate func setupNavigationBar() {
        let logoImage = UIImage(named: "logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        let collectionImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectionImage, style: .plain, target: self, action: #selector(collectItemClick))
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let navView: UIView = UIView(frame: searchFrame)
        let searchBar = UISearchBar(frame: navView.bounds)
        searchBar.searchTextField.placeholder = "主播昵称/房间号/链接"
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .prominent
        searchBar.tintColor = .gray
        navView.addSubview(searchBar)
        navigationItem.titleView = navView
    }
    fileprivate func setupContentView() {
        //1.获取数据
        let homeTypes = loadTypesData()
        let titles = homeTypes.map({$0.title})
        let style: LDTitleStyle = LDTitleStyle()
        style.isScoreEnable = true
        let pageFrame = CGRect(x: 0, y: kNavigationBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kTabbarH)

        var vcs: [AnchorViewController] = []
        for type in homeTypes {
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            vcs.append(anchorVc)
        }
        
        let pageView: LDPageView = LDPageView(frame: pageFrame, titles:titles , style: style, childVcs: vcs, parentVc: self)
        view.addSubview(pageView)
        
    }
    fileprivate func loadTypesData() -> [HomeType]{
        let path = Bundle.main.path(forResource: "types", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!) as! [[String:Any]]
       return modelArray(from: dataArray, HomeType.self)
    }
    
}
//MARK: - 事件处理
extension HomeViewController {
    @objc fileprivate func collectItemClick(){
        print("弹出收藏控制器")
    }
}
