//
//  FileManagerProtocol.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/03.
//

import Foundation

protocol FileManagerProtocol {
    func getImageDataFromCache(imageURL : URL) -> Data?
    func saveImageDataIntoCache(imageURL : URL, imageData : Data)
    func copyImageDataIntoCache(fromURL : URL, targetURL : URL, completionHandler : @escaping (Data) -> ())
    func createFilePath(imageURL : URL) -> URL?
}
