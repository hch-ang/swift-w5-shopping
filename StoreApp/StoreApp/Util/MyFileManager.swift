//
//  MyFileManager.swift
//  StoreApp
//
//  Created by Hochang Lee on 2021/02/02.
//

import Foundation

class MyFileManager : FileManagerProtocol {
    func getImageDataFromCache(imageURL : URL) -> Data? {
        guard let filePath = createFilePath(imageURL: imageURL) else { return nil }

        let fileManager = FileManager()
        if fileManager.fileExists(atPath: filePath.path) {
            guard let imageData = try? Data(contentsOf: filePath) else { return nil }
            return imageData
        } else {
            return nil
        }
    }
    
    func saveImageDataIntoCache(imageURL : URL, imageData : Data) {
        guard let filePath = createFilePath(imageURL: imageURL) else { return }
        
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: filePath.path) {
            fileManager.createFile(atPath: filePath.path, contents: imageData, attributes: nil)
        }
    }
    
    func copyImageDataIntoCache(fromURL : URL, targetURL : URL, completionHandler : @escaping (Data) -> ()) {
        guard let toURL = createFilePath(imageURL: targetURL) else { return }
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: fromURL.path) {
            do {
                try fileManager.copyItem(atPath: fromURL.path, toPath: toURL.path)
            } catch {
                return
            }
            guard let data = getImageDataFromCache(imageURL: targetURL) else { return }
            completionHandler(data)
        }
    }
    
    func createFilePath(imageURL : URL) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil}
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(imageURL.query ?? imageURL.path)
        return filePath
    }
}

