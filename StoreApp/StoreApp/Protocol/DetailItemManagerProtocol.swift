//
//  DetailManagerProtocol.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

protocol DetailItemManagerProtocol {
    func getPreviewImages() -> [String]
    func getTotalProductStarRating() -> Double
    func getReviewCount() -> Int
    func getStandardPrice() -> Int
    func getStatus() -> String
    func getDiscountedPrice() -> Int
    func getStoreName() -> String
    func getProductName() -> String
    func getDeliveryFeeType() -> String
    func getDeliveryFee() -> Int
    func getNoticeCount() -> Int
    func getNoticeTitle() -> String?
    func getNoticeCreatedAt() -> String?
    func getDescription() -> String}
