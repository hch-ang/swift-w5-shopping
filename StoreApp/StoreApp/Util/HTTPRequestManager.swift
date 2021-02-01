//
//  HTTPRequestManager.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class HTTPRequestManager {
    
    static func getJsonData(itemCase : ItemManager.jsonPath) {
        let session = URLSession.shared
        guard let dataURL = URL(string: "http://public.codesquad.kr/jk/kakao-2021/\(itemCase.rawValue).json") else { return }
        session.dataTask(with: dataURL) {
            data, response, error in
            guard error == nil else {
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let resultArray : [StoreItem] = try JSONDecoder().decode([StoreItem].self, from: data)
                    ItemManager.saveItems(itemCase: itemCase, resultArray: resultArray)
                    DispatchQueue.main.async {
                        //
                    }
                } catch(let error) {
                    print(error)
                }
            }
        }.resume()
    }
}
