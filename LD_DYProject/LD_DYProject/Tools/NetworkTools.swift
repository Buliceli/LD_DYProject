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
  class  func requestData(_ type: MethodType,URLString: String,parameters: [String : Any]? = nil, finishedCallback : @escaping (_ result: Any)->()) -> () {
        //获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //发送网络请求
        request(URLString,method: method,parameters: parameters).responseJSON { (response) in
            //获取结果
            switch response.result {
            case .success:
              let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
              finishedCallback(dict ?? [])
            case let .failure(error):
                print(error)
            }
        }
    }
}
