//
//  HomeViewModel.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{
    @Published var categories = [Category]()
    @Published var carts = [Cart]()
    @Published var error: Error?
    
    
    
    func loadAllProducts(){
        //data not in coredata
        if DatabaseService.shared.isCoreDataEmpty(){
            //load from json and save to coredata and read from core data
            self.getAllProductsFromJSON()
        }
        //data in coredata
        else{
            //only read from coredata
            self.getAllProductsFromCoreData()
        }
    }
    
    func getAllProductsFromJSON(){
        let result = FileService.shared.loadJSONFile(responseType: ResponseModel.Root.self)
        switch result {
        case .success(let response):
            if let categories = response.categories{
                DatabaseService.shared.saveData(categories: categories) { error  in
                    if let error{
                        self.error = error
                    }
                    self.getAllProductsFromCoreData()
                }
          
            }
            break
        case .failure(let error):
            self.error = error
            break
        }
    }
    
    func getAllProductsFromCoreData(){
        let result = DatabaseService.shared.getAllData(fetchRequest: Category.fetchRequest())
        switch result {
        case .success(let data):
           
            self.categories = data
             break
        case .failure(let error):
            self.error = error
            break
            
        }
    }
    
    func saveItemToCart(id: String,name: String,units: Int,imageURL: String,price: String){
        if let cartItemToBeUpdated = self.carts.filter({ cartItem in
            (cartItem.id ?? "") == id
        }).first{
           
            
            print("UPDATE DATA")
            DatabaseService.shared.updateCartItemQuantity(cartItemToBeUpdated: cartItemToBeUpdated)
        }
        else{
            DatabaseService.shared.saveItemsToCart(id: id, name: name, units: units, imageURL: imageURL, price: price)
            self.getAllDatafromCart()
        }
      
    }
    
    func getAllDatafromCart(){
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let result = DatabaseService.shared.getAllData(fetchRequest: Cart.fetchRequest(),sortDescriptors: [sortDescriptor])
        switch result {
        case .success(let data):
            self.carts = data
            break
        case .failure(let error):
            self.error = error
            break
        }
    }
    
    func updateLikeStatus(itemLiked: Item,isLiked: Bool){
        itemLiked.isLiked = isLiked
        do{
            try DatabaseService.shared.context.save()
           // self.loadAllProducts()
        }
        catch{
            self.error = error
            print(error)
        }
    }
    
    
    
    
}
