//
//  JsonModels.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class ItemManager {
    enum jsonPath : String, CaseIterable {
    case best = "http://public.codesquad.kr/jk/kakao-2021/best.json"
    case mask = "http://public.codesquad.kr/jk/kakao-2021/mask.json"
    case grocery = "http://public.codesquad.kr/jk/kakao-2021/grocery.json"
    case fryingpan = "http://public.codesquad.kr/jk/kakao-2021/fryingpan.json"
    }

    static var bestItems : [StoreItem] = []
    static var maskItems : [StoreItem] = []
    static var groceryItems : [StoreItem] = []
    static var fryingpanItems : [StoreItem] = []
    
    static func loadData(itemCase : jsonPath) {
        let session = URLSession.shared
        guard let dataURL = URL(string: itemCase.rawValue) else { return }
        session.dataTask(with: dataURL) {
            data, response, error in
            guard error == nil else {
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let resultArray : [StoreItem] = try JSONDecoder().decode([StoreItem].self, from: data)
                    saveData(itemCase: itemCase, resultArray: resultArray)
                    DispatchQueue.main.async {
                        //
                    }
                } catch(let error) {
                    print(error)
                }
            }
        }.resume()
    }
    
    static func saveData(itemCase : jsonPath, resultArray : [StoreItem]) {
        switch itemCase {
        case .best:
            bestItems = resultArray
        case .fryingpan:
            fryingpanItems = resultArray
        case .grocery:
            groceryItems = resultArray
        default:
            maskItems = resultArray
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
