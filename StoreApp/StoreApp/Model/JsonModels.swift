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
        
        var SectionName : String{
            switch self {
            case .best : return "베스트"
            case .mask : return "마스크"
            case .grocery : return "잡화"
            case .fryingpan : return "프래이팬"
            }
        }
    }

    static var bestItems : [StoreItem] = []
    static var maskItems : [StoreItem] = []
    static var groceryItems : [StoreItem] = []
    static var fryingpanItems : [StoreItem] = []
    
    static func setItems(itemType : ItemType, completionHandler : @escaping () -> Void) {
        switch itemType {
        case .best:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (itemArray) in
                bestItems = itemArray
                completionHandler()
            }
            return
        case .fryingpan:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (itemArray) in
                fryingpanItems = itemArray
                completionHandler()
            }
            return
        case .grocery:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (itemArray) in
                groceryItems = itemArray
                completionHandler()
            }
            return
        case .mask:
            HTTPRequestManager.getJsonData(itemType: itemType) {
                (itemArray) in
                maskItems = itemArray
                completionHandler()
            }
            return
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


struct detailItem: Codable {
    let result: Bool
    let data: DataClass
    
}

struct DataClass: Codable {
    let gift: String
    let benefits: [String]
    let booked: Bool
    let dataDescription: String
    let previewImages: [String]
    let optionType: String
    let certTypeFood: Bool
    let price: Price
    let review: Review
    let id: Int
    let reviewCreatable: Bool
    let events: [JSONAny]
    let delivery: Delivery
    let images: [String]
    let quantity: Quantity
    let coupon: Bool
    let store: Store
    let taxDeduction: Bool
    let notices: [JSONAny]
    let imageRatio: String
    let adultOnly: Bool
    let name: String
    let category: Category
    let favorite: Bool
    let sharingImageURL: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case gift, benefits, booked
        case dataDescription = "description"
        case previewImages, optionType, certTypeFood, price, review, id, reviewCreatable, events, delivery, images, quantity, coupon, store, taxDeduction, notices, imageRatio, adultOnly, name, category, favorite
        case sharingImageURL = "sharingImageUrl"
        case status
    }
}

// MARK: - Category
struct Category: Codable {
    let id, name: String
}

// MARK: - Delivery
struct Delivery: Codable {
    let deliveryMethodType: String
    let optionalDeliveries: [JSONAny]
    let deliveryFeeType, deliveryFeePaymentType: String
    let deliveryFee: Int
    let bundleGroupAvailable: Bool
    let isolatedAreaNotice: String
}

// MARK: - Price
struct Price: Codable {
    let standardPrice, discountedPrice: Int
    let discountRate: String
    let minDiscountedPrice, maxDiscountedPrice: Int
}

// MARK: - Quantity
struct Quantity: Codable {
    let maxPurchase, maxPurchaseOfBuyer: Int
}

// MARK: - Review
struct Review: Codable {
    let topReviews: [TopReview]
    let qnaCount, reviewCount, averageRating: Int
    let totalProductStarRating: Double
    let totalDeliveryStarRating, productPositivePercentage, deliveryPositivePercentage, productStar1Percentage: Int
    let productStar2Percentage, productStar3Percentage, productStar4Percentage: Int
}

// MARK: - TopReview
struct TopReview: Codable {
    let id, content: String
    let productRating, deliveryRating, productStarRating, deliveryStarRating: Int
    let best: Bool
    let writer: String
    let imageURL: String
    let backgroundColor: String

    enum CodingKeys: String, CodingKey {
        case id, content, productRating, deliveryRating, productStarRating, deliveryStarRating, best, writer
        case imageURL = "imageUrl"
        case backgroundColor
    }
}

// MARK: - Store
struct Store: Codable {
    let id: Int
    let name, domain: String
    let farmer: Bool
    let coverImage, profileImage: String
    let introduce, channelName: String
    let channelURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, domain, farmer, coverImage, profileImage, introduce, channelName
        case channelURL = "channelUrl"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
