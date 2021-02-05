//
//  DetailManagerProtocol.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation
import UIKit

protocol DetailItemManagerProtocol {
    func setItem(storeDomain : String, productId : String)
    func setPreviewImages(completionHandler : () -> ())
    func getPreviewImage(index : Int) -> UIImage
    var previewImageCount : Int { get }
    var previewImages : [String] { get }
    var totalProductStarRating : Double { get}
    var reviewCount : Int { get }
    var standardPrice: Int { get }
    var status : String { get }
    var discountedPrice : Int { get }
    var storeName : String { get }
    var productName : String { get }
    var deliveryFeeType : String { get }
    var deliveryFee : Int { get }
    var noticeCount : Int { get }
    var noticeTitle : String? { get }
    var noticeCreatedAt : String? { get }
    var description : String { get }
}
