//
//  StudentData.swift
//  Somday
//
//  Created by 김예은 on 2020/08/31.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation

struct StudentData: Codable {
    let status: Int
    let message: String
    let data: Student
}

struct Student: Codable {
    let name: String
    let studentId: String
    let step: String
    let major: Major
}
