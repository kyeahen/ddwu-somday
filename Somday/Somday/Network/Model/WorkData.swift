//
//  WorkData.swift
//  Somday
//
//  Created by 김예은 on 2020/08/27.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation 

struct WorkData: Codable {
    let status: Int
    let message: String
    let data: Work?
}

struct Work: Codable {
    let id: Int
    let studentId : String
    let registeredAt : String
    let room: Room
}

struct Room: Codable {
    let id : Int
    let name: String
    let majorId: Int?
}

struct WorkRoomData: Codable {
    let status: Int
    let message: String
    let data: [Room]
}
