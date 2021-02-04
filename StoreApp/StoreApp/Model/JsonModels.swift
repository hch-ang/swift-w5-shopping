//
//  JsonModels.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class ItemManager {
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

    static var bestItems : [StoreItem] = []
    static var maskItems : [StoreItem] = []
    static var groceryItems : [StoreItem] = []
    static var fryingpanItems : [StoreItem] = []
    
    static func setAllTypeOfItems() {
        for itemType in ItemType.allCases {
            setItems(itemType: itemType) {
                NotificationCenter.default.post(name: .FinishedItemSet, object: self, userInfo: ["itemType" : itemType])
            }
        }
    }
    
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

class DetailItemManager : DetailManagerProtocol{
    static private var detailItem : DetailItem!
    static func setItem(storeDomain : String, productId : String) {
        HTTPRequestManager.getJsonDataOfDetail(storeDomain: storeDomain, productId: productId) {
            (item) in
            detailItem = item
        }
    }
    
    func getPreviewImages() -> [String] {
        return DetailItemManager.detailItem.data.previewImages
    }
    
    func getTotalProductStarRating() -> Double {
        return DetailItemManager.detailItem.data.review.totalProductStarRating
    }
    
    func getReviewCount() -> Int {
        return DetailItemManager.detailItem.data.review.reviewCount
    }
    
    func getStatus() -> String {
        return DetailItemManager.detailItem.data.status
    }
    
    func getDiscountedPrice() -> Int {
        return DetailItemManager.detailItem.data.price.standardPrice
    }
    
    func getStoreName() -> String {
        return DetailItemManager.detailItem.data.store.name
    }
    
    func getDeliveryFeeType() -> String {
        return DetailItemManager.detailItem.data.delivery.deliveryFeeType
    }
    
    func getDeliveryFee() -> Int {
        return DetailItemManager.detailItem.data.delivery.deliveryFee
    }
    
    func getNoticeTitle() -> String? {
//        return DetailItemManager.detailItem.data.notices
        return nil
    }
    
    func getNoticeProduceAt() -> String? {
        return nil
    }
    

}

struct DetailItem: Codable {
    let result: Bool
    let data: DataClass
    
}

struct DataClass: Codable {
    let previewImages: [String]
    let price: Price
    let review: Review
    let delivery: Delivery
    let store: Store
    let talkDeal : TalkDeal?
    let notices: [Notice]
    let status: String

    enum CodingKeys: String, CodingKey {
        case previewImages, price, review, delivery, store, talkDeal, notices, status
    }
}

// MARK: - Delivery
struct Delivery: Codable {
    let deliveryFeeType : String
    let deliveryFee: Int
}

// MARK: - Price
struct Price: Codable {
    let standardPrice: Int
}

// MARK: - Review
struct Review: Codable {
    let reviewCount : Int
    let totalProductStarRating: Double
}

// MARK: - Store
struct Store: Codable {
    let name: String
}

// MARK: - TalkDeal
struct TalkDeal: Codable {
    let status: String
    let discountPrice : Int
}

// MARK: - Notice
struct Notice: Codable {
    let title: String
    let createdAt : String
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

extension Notification.Name {
    static let FinishedItemSet = Notification.Name("FinishedItemSet")
    static let DetailViewDataIsReady = Notification.Name("DetailViewDataIsReady")
}

