//
//  DetailManagerProtocol.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

protocol DetailManagerProtocol {
    func getPreviewImages() -> [String]
    func getTotalProductStarRating() -> Double
    func getReviewCount() -> Int
    func getStatus() -> String
    func getDiscountedPrice() -> Int
    func getStoreName() -> String
    func getDeliveryFeeType() -> String
    func getDeliveryFee() -> Int
    func getNoticeTitle() -> String?
    func getNoticeProduceAt() -> String?
}
