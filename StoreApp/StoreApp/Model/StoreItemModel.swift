//
//  JsonModels.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class StoreItemManager : StoreItemManagerProtocol{

    private var bestItems : [StoreItem] = []
    private var maskItems : [StoreItem] = []
    private var groceryItems : [StoreItem] = []
    private var fryingpanItems : [StoreItem] = []
    
    func setAllTypeOfItems() {
        for itemType in ItemType.allCases {
            setItems(itemType: itemType) {
                NotificationCenter.default.post(name: .FinishedItemSet, object: self, userInfo: ["itemType" : itemType])
            }
        }
    }
    
    func setItems(itemType : ItemType, completionHandler : @escaping () -> Void) {
        switch itemType {
        case .best:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (data) in
                let resultArray = JsonHandler.shared.parseIntoArr(data: data, toType: StoreItem.self)
                self.bestItems = resultArray
                completionHandler()
            }
            return
        case .fryingpan:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (data) in
                let resultArray = JsonHandler.shared.parseIntoArr(data: data, toType: StoreItem.self)
                self.fryingpanItems = resultArray
                completionHandler()
            }
            return
        case .grocery:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (data) in
                let resultArray = JsonHandler.shared.parseIntoArr(data: data, toType: StoreItem.self)
                self.groceryItems = resultArray
                completionHandler()
            }
            return
        case .mask:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (data) in
                let resultArray = JsonHandler.shared.parseIntoArr(data: data, toType: StoreItem.self)
                self.maskItems = resultArray
                completionHandler()
            }
            return
        }
    }
    
    func getItems(itemType : ItemType) -> [StoreItem] {
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
    
    func getCount(itemType : ItemType) -> Int {
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
    
    func subccript(itemType : ItemType, index : Int) -> StoreItem {
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

struct StoreItem: Codable, Hashable {
    let identifier = UUID()
    let productName: String
    let productImage: String
    let groupDiscountedPrice: Int?
    let originalPrice: Int
    let groupDiscountUserCount: Int?
    let storeDomain : String
    let productId : Int

    enum CodingKeys: String, CodingKey {
        case productName, productImage, originalPrice, groupDiscountedPrice, groupDiscountUserCount, storeDomain, productId
    }
    
}
