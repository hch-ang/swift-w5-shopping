//
//  HTTPRequestManager.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation

class HTTPRequestManager {
    
    static let fileManager : FileManagerProtocol = MyFileManager()
    
    static func getJsonData(itemType : ItemType, completionHandler : @escaping (Data) -> Void) {
        let session = URLSession.shared
        guard let dataURL = URL(string: "http://public.codesquad.kr/jk/kakao-2021/\(itemType.rawValue).json") else { return }
        session.dataTask(with: dataURL) {
            data, response, error in
            guard error == nil else {
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completionHandler(data)
            }
        }.resume()
    }
    
    static func getJsonDataOfDetail(storeDomain : String, productId : String, completionHandler : @escaping (Data) -> Void) {
        guard let detailDataURL = URL(string: "https://store.kakao.com/a/\(storeDomain)/product/\(productId)/detail") else { return }
        URLSession.shared.dataTask(with: detailDataURL) {
            data, response, error in
            guard error == nil else {
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completionHandler(data)
            }
        }.resume()
    }
    
    static func getImageUsingURLString(urlString : String, completionHandler : @escaping (Data) -> Void) {
        guard let imageURL = URL(string: urlString) else { return }
        
        if let imageData = fileManager.getImageDataFromCache(imageURL: imageURL) {
            completionHandler(imageData)
            return
        }
        
        URLSession.shared.downloadTask(with: imageURL) {
            url, urlResponse, error in
            guard let url = url else { return }
            fileManager.copyImageDataIntoCache(fromURL: url, targetURL: imageURL) {
                (data) in
                completionHandler(data)
            }
        }.resume()
    }
}

