//
//  HomeViewModel.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{
    //MARK: - PROPERTIES
    @Published var categories = [Category]()
    @Published var carts = [Cart]()
    @Published var error: Error?
    
    private var favorites = [Favorite]()
    
    func loadAllProducts(){
        //if data is not in coredata
        if self.isCoreDataEmpty(){
            //load from json and save to coredata and read from core data
            self.getAllProductsFromJSON()
        }
        //if data is in coredata
        else{
            //only read from coredata
            self.getAllProductsFromCoreData()
        }
    }
    
    //Check if the core data is empty with no category data
    func isCoreDataEmpty() -> Bool{
        if let categories = try? DatabaseService.shared.context.fetch(Category.fetchRequest()){
            return categories.isEmpty
        }
        
        return true
    }
    
    //Load the JSON file -> Parse it -> Save it to the core data
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
    
    //Get the saved products from core data
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
    
    //Save the item to the cart
    func saveItemToCart(id: String,name: String,units: Int,imageURL: String,price: String){
        //If  the item is in cart then update its quantity of the item alone
        if let cartItemToBeUpdated = self.carts.filter({ cartItem in
            (cartItem.id ?? "") == id
        }).first{
           
            
            print("UPDATE DATA")
            DatabaseService.shared.updateCartItemQuantity(cartItemToBeUpdated: cartItemToBeUpdated)
        }
        //If the item is not in cart then save it to the cart
        else{
            DatabaseService.shared.saveItemsToCart(id: id, name: name, units: units, imageURL: imageURL, price: price)
            
        }
        self.getAllDatafromCart()
      
    }
    //Get all the data from cart
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
    //Update the like status of the item
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
    //Get all the favorite from core data
    func getAllFavorites(){
            let result = DatabaseService.shared.getAllData(fetchRequest: Favorite.fetchRequest())
            switch result {
            case .success(let data):
                self.favorites = data
            case .failure(let error):
                self.error = error
            }
    }
    //Add the item to favorite
    func addItemToFavorite(itemLiked: Item,isLiked: Bool){
        self.getAllFavorites()
        if isLiked == false{
            //remove from item from favorite core data if the item is disliked
            if let itemToBeRemoved = self.favorites.filter({ item  in
                (item.id ?? "") == (itemLiked.id ?? "")
            }).first{
                DatabaseService.shared.context.delete(itemToBeRemoved)
                do{
                    try DatabaseService.shared.context.save()
                }
                catch{
                    self.error = error
                }
            }
            
        }
        else{
            //add it to favorite core data if the item is liked
            let itemToFavorite = Favorite(context: DatabaseService.shared.context)
            itemToFavorite.id = itemLiked.id ?? ""
            itemToFavorite.name = itemLiked.name ?? ""
            itemToFavorite.price = itemLiked.price
            itemToFavorite.isLiked = isLiked
            itemToFavorite.unit = 1
            itemToFavorite.icon = itemLiked.icon ?? ""
            do{
                try DatabaseService.shared.context.save()
            }
            catch{
                self.error = error
                print(error)
            }
        }
        
        
        
    }
    
    
    
    
}
