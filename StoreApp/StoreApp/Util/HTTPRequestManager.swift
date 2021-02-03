//
//  HTTPRequestManager.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class HTTPRequestManager {
    
    static func getJsonData(itemType : ItemManager.ItemType, completionHandler : @escaping ([StoreItem]) -> Void) {
        let session = URLSession.shared
        guard let dataURL = URL(string: "http://public.codesquad.kr/jk/kakao-2021/\(itemType.rawValue).json") else { return }
        session.dataTask(with: dataURL) {
            data, response, error in
            guard error == nil else {
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let resultArray = JsonHandler.shared.parse(data: data, toType: StoreItem.self)
                    completionHandler(resultArray)
            }
        }.resume()
    }
    
    static func getImageUsingURLString(urlString : String, completionHandler : @escaping (Data) -> Void) {
        guard let imageURL = URL(string: urlString) else { return }
        
        if let imageData = MyFileManager.getImageDataFromCache(imageURL: imageURL) {
            completionHandler(imageData)
            return
        }
        
        URLSession.shared.downloadTask(with: imageURL) {
            url, urlResponse, error in
            guard let url = url else { return }
            MyFileManager.copyImageDataIntoCache(fromURL: url, targetURL: imageURL) {
                (data) in
                completionHandler(data)
            }
        }.resume()
    }
}

