//
//  NoticeData.swift
//  Somday
//
//  Created by 김예은 on 2020/08/29.
//  Copyright © 2020 kyeahen. All rights reserved.
//

import Foundation

//기본 model
struct NoticeData: Codable {
    let status: Int
    let message: String
    let data: NoticePaging
}

struct NoticePaging: Codable {
    let noticeList: [Notice]
    let pagination : Paging
}

struct Notice: Codable {
    let id: Int
    let category: Category
    let major: Major?
    let title: String
    let content: String
    let images: [NoticeImage]?
    let registeredAt: String
    let updatedAt: String
}

struct Category: Codable {
    let id: String
    let name: String
}

struct Major: Codable {
    let id: Int
    let name: String
}

struct Paging: Codable {
    let pageSize: Int
    let page: Int
    let remainPage: Int
}

//상단 고정 model
struct TopData: Codable {
    let status: Int
    let message: String
    let data: TopNotice?
}

struct TopNotice: Codable {
    let id: Int
    let category: Category
    let major: Major
    let title: String
    let content: String
    let images: [NoticeImage]?
    let registeredAt: String
    let updatedAt: String
}

//상세보기 model
struct DetialData: Codable {
    let status: Int
    let message: String
    let data: Detail
}

struct Detail: Codable{
    let id: Int
    let category: Category
    let major: Major?
    let title: String
    let content: String
    let images: [NoticeImage]
    let registeredAt: String
    let updatedAt: String
}

struct NoticeImage: Codable {
    let id: Int
    let imageUrl: String
}

//검색 model
struct SearchData: Codable {
    let status: Int
    let message: String
    let data: [Notice]?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


