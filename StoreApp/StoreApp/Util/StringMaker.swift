//
//  StringMaker.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

class StringMaker {
    static func makeGroupDiscountedPriceString(price : Int?) -> String {
        if let price = price {
            return  "톡딜가 \(String(price))원"
        } else {
            return ""
        }
    }
    
    static func makeOriginalPriceString(price : Int) -> String {
        return "\(String(price))원"
    }
    
    static func makeGroudDiscountUserCountString(count : Int?) -> String {
        if let count = count {
            return "현재 \(String(count))명 딜 참여중"
        } else {
            return "현재 0명 딜 참여중"
        }
    }
}
