//
//  StringMaker.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

class ShoppingItemCellStringMaker {
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

class DetailViewStringMaker {
    static func makeTotalProductStarRankingAndReviewCountString(totalProductStarRating : Double, reviewCount : Int) -> String{
        return "\(String(repeating: "★", count: Int(totalProductStarRating))) 리뷰 \(reviewCount)건"
    }
    
    static func convertStandardPriceIntoString(standardPrice : Int) -> String {
        return "바로 구매 \(StandardStringMaker.makeIntegerToFitStandard(num: standardPrice))원"
    }
    
    static func convertDiscountedPriceIntoString(discountedPrice : Int) -> String {
        return "바로 구매 \(StandardStringMaker.makeIntegerToFitStandard(num: discountedPrice))원"
    }
    
    static func makeDeilveryFeeString(deliveryFee : Int, deliveryFeeType : String) -> String {
        return deliveryFeeType == "FREE" ? "배송비 무료" : "배송비 \(deliveryFee)원"
    }
    
    static func makeNoticeCreatedAtToFitStandard(createdAt : String?) -> String {
        guard let createdAt = createdAt else { return "" }
        let startIndex = createdAt.startIndex
        let range1 = startIndex..<createdAt.index(startIndex, offsetBy: 4)
        let range2 = createdAt.index(startIndex, offsetBy: 4)..<createdAt.index(startIndex, offsetBy: 6)
        let range3 = createdAt.index(startIndex, offsetBy: 6)..<createdAt.index(startIndex, offsetBy: 8)
        return "\(createdAt[range1]).\(createdAt[range2]).\(createdAt[range3])"
    }
}

class StandardStringMaker {
    static func makeIntegerToFitStandard(num : Int) -> String {
        var resultString = ""
        var count = num
        while count > 0 {
            let num = count % 1000
            count /= 1000
            var tempstr = String(num)
            if resultString.count == 0 {
                if count == 0 {
                    resultString = tempstr
                }
                else {
                    while tempstr.count < 3 {
                        tempstr = "0\(tempstr)"
                    }
                    resultString = tempstr
                }
            } else {
                if count == 0 {
                    resultString = "\(tempstr),\(resultString)"
                }
                else {
                    while tempstr.count < 3 {
                        tempstr = "0\(tempstr)"
                    }
                    resultString = "\(tempstr),\(resultString)"
                }
            }
        }
        return resultString
    }}

class DetailViewLogicHelper {
    static func isOnSale(status : String) -> Bool {
        return status == "ON_SALE"
    }
}
