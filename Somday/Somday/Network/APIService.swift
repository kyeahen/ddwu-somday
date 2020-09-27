//
//  APIService.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

protocol APIServie {
    
}

extension APIServie {
    
    func url(_ path: String) -> String {
        return "http://15.165.176.151:8080/Somday" + path
    }
}

