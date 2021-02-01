//
//  JsonModels.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

struct StoreItem: Codable {
    let productName: String
    let productImage: String
    let groupDiscountedPrice: Int
    let originalPrice: Int
    let groupDiscountUserCount: Int?

    enum CodingKeys: String, CodingKey {
        case productName, productImage, originalPrice, groupDiscountedPrice, groupDiscountUserCount
    }
}
