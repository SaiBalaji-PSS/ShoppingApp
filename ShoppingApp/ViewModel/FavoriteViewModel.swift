//
//  FavoriteViewModel.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation
import Combine

class FavoriteViewModel: ObservableObject{
    
    @Published var error: Error?
    @Published var favoriteItems = [Favorite]()
    
    func getAllFavoriteItems(){
        let result = DatabaseService.shared.getAllData(fetchRequest: Favorite.fetchRequest())
        switch result {
        case .success(let data):
            self.favoriteItems = data
            break
        case .failure(let error):
            self.error = error
            break
        }
    }
    
    func updateItemUnitCount(item: Favorite,unit: Int,price: Double){
        item.unit = Int64(unit)
        item.price = price * Double(unit)
        do{
            try DatabaseService.shared.context.save()
        }
        catch{
            self.error = error
        }
    }
    
    
}
