//
//  HomeViewModel.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{
    @Published var categories = [ResponseModel.Category]()
    @Published var error: Error?
    
    func getAllProducts(){
        let result = FileService.shared.loadJSONFile(responseType: ResponseModel.Root.self)
        switch result {
        case .success(let response):
            if let categories = response.categories{
                self.categories = categories
            }
        case .failure(let error):
            self.error = error
        }
    }
}
