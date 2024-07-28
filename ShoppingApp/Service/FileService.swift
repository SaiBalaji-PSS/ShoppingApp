//
//  NetworkService.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation

enum FileServiceError: Error{
    case invalidFileURL(url: String)
}
extension FileServiceError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .invalidFileURL(let url):
            return "The given file url is invalid"
        }
    }
}
class FileService{
    static var shared = FileService()
    private init(){}
    func loadJSONFile<T: Codable>(responseType: T.Type) -> Result<T,Error>{
        let fileURL = Bundle.main.url(forResource: "Products", withExtension: "json")
        guard let fileURL = fileURL else{return .failure(FileServiceError.invalidFileURL(url: fileURL?.absoluteString ?? "")) }
        do{
            let jsonFileData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode(T.self, from: jsonFileData)
            print(decodedData)
            return .success(decodedData)
            
        }
        catch{
            print(error)
            return .failure(error)
        }
    }
}
