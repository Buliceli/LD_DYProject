//
//  NetworkTools.swift
//  LD_DYProject
//
//  Created by 李洞洞 on 2020/4/21.
//  Copyright © 2020 李洞洞. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    func requestData(_ type: MethodType,URLString: String,parameters: [String : Any]? = nil, finishedCallback : (_ result: Any)->()) -> () {
        //获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //发送网络请求
//        request(URLString,method,parameters).responseJSON {
//            (resonse) in
//
//        }
     
         // 2.发送网络请求
//        (Alamofire.request(URLString, method: method, parameters: parameters) as AnyObject).responseJSON { (response) in
//
//                   // 3.获取结果
//                   guard let result = response.result.value else {
//                       print(response.result.error!)
//                       return
//                   }
//
//                   // 4.将结果回调出去
//                finishedCallback(result)}
//
    }
}
