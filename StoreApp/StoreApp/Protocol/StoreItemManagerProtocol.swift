//
//  StoreItemManagerProtocol.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/04.
//

import Foundation

protocol StoreItemManagerProtocol {
    func setAllTypeOfItems()
    func setItems(itemType : ItemType, completionHandler : @escaping () -> Void)
    func getItems(itemType : ItemType) -> [StoreItem]
    func getCount(itemType : ItemType) -> Int
    func subccript(itemType : ItemType, index : Int) -> StoreItem
}

enum ItemType : String, CaseIterable, CustomStringConvertible {
    case best
    case mask
    case grocery
    case fryingpan
    
    var description: String {
        switch self {
        case .best : return "베스트"
        case .mask : return "마스크"
        case .grocery : return "잡화"
        case .fryingpan : return "프래이팬"
        }
    }
}
