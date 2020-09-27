//
//  MemoData.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation

struct MemoData: Codable {
    let status: Int
    let message: String
    let data: [Memo]
}

struct Memo: Codable {
    let id: Int
    let content: String
    let checked: Bool
}
