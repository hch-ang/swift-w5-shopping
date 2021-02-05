//
//  HTTPRequestManager.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/01.
//

import Foundation
import UIKit

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
    
    static func getImageArrayUsingURLStringArray(urlStrings : [String], completionHandler : @escaping ([Data]) -> ()) {
        var resultArr : [Data] = []
        for urlString in urlStrings {
            guard let imageURL = URL(string: urlString) else { continue }
            if let imageData = fileManager.getImageDataFromCache(imageURL: imageURL) {
                resultArr.append(imageData)
                continue
            }
            
            URLSession.shared.downloadTask(with: imageURL) {
                url, urlResponse, error in
                guard let url = url else { return }
                fileManager.copyImageDataIntoCache(fromURL: url, targetURL: imageURL) {
                    (data) in
                    resultArr.append(data)
                }
            }.resume()
        }
        completionHandler(resultArr)
    }
    
    static func sendPost(paramText: String, urlString: String) {
        let url = URL(string: urlString)
        let jsonDictionary = ["text" : paramText]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: []) else {
            return
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let e = error {
              NSLog("An error has occured: \(e.localizedDescription)")
              return
            }
            DispatchQueue.main.async() {
                let outputStr = String(data: data!, encoding: String.Encoding.utf8)
                print("result: \(outputStr!)")
            }
        }
        task.resume()
    }
}

