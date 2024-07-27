//
//  CartViewModel.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation
import Combine

class CartViewModel: ObservableObject{
    @Published var cartItems = [Cart]()
    @Published var error: Error?
    func getAllCartItems(){
        let result = DatabaseService.shared.getAllData(fetchRequest: Cart.fetchRequest())
        switch result {
        case .success(let data):
            self.cartItems = data
            break
        case .failure(let error):
            self.error = error
            break
        }
    }
    func updateCartItemQuantity(item: Cart,quantity: Int64){
        
        item.quantity = quantity
        do{
            try DatabaseService.shared.context.save()
        }
        catch{
            self.error = error
        }
    }
    func removeItemFromCart(item: Cart){
        DatabaseService.shared.context.delete(item)
        do{
            try DatabaseService.shared.context.save()
        }
        catch{
            self.error = error
        }
    }
}
