//
//  JsonModels.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class ItemManager {
    enum ItemType : String, CaseIterable {
    case best
    case mask
    case grocery
    case fryingpan
    }

    static var bestItems : [StoreItem] = []
    static var maskItems : [StoreItem] = []
    static var groceryItems : [StoreItem] = []
    static var fryingpanItems : [StoreItem] = []
    
    static func saveItems(itemType : ItemType, resultArray : [StoreItem]) {
        switch itemType {
        case .best:
            bestItems = resultArray
        case .fryingpan:
            fryingpanItems = resultArray
        case .grocery:
            groceryItems = resultArray
        case .mask:
            maskItems = resultArray
        }
    }
    
    static func getItems(itemType : ItemType) -> [StoreItem] {
        switch itemType {
        case .best:
            return bestItems
        case .fryingpan:
            return fryingpanItems
        case .grocery:
            return groceryItems
        case .mask:
            return maskItems
        }
    }
    
    static func getCount(itemType : ItemType) -> Int {
        switch itemType {
        case .best:
            return bestItems.count
        case .fryingpan:
            return fryingpanItems.count
        case .grocery:
            return groceryItems.count
        case .mask:
            return maskItems.count
        }
    }
    
    static func subccript(itemType : ItemType, index : Int) -> StoreItem {
        switch itemType {
        case .best:
            return bestItems[index]
        case .fryingpan:
            return fryingpanItems[index]
        case .grocery:
            return groceryItems[index]
        case .mask:
            return maskItems[index]
        }
    }
}

struct StoreItem: Codable {
    let productName: String
    let productImage: String
    let groupDiscountedPrice: Int?
    let originalPrice: Int
    let groupDiscountUserCount: Int?

    enum CodingKeys: String, CodingKey {
        case productName, productImage, originalPrice, groupDiscountedPrice, groupDiscountUserCount
    }
}
