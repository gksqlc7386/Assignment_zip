//
//  Book.swift
//  Assignment_7
//
//  Created by Luz on 5/9/24.
//

import Foundation

struct Book: Codable {
    let documents: [Document]
}

struct Document: Codable {
    let authors: [String]
    let contents, datetime, isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, translators
    }
}
