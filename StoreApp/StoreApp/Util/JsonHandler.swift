//
//  JsonHandler.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

class JsonHandler {
    static let shared = JsonHandler()
    
    private init() { }
    
    func parseIntoArr<T : Codable>(data : Data, toType : T.Type) -> [T]{
        guard let resultArray : [T] = try? JSONDecoder().decode([T].self, from: data) else { return [] }
        return resultArray
    }
    
    func parse<T : Codable>(data : Data, toType : T.Type) -> T? {
        guard let result : T = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return result
    }
}
