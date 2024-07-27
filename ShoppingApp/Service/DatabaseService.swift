//
//  DatabaseService.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import Foundation
import UIKit


class DatabaseService{
    static var shared = DatabaseService()
    private init(){}
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveData(categories: [ResponseModel.Category],onCompletion:@escaping(Error?)->(Void)){
        categories.forEach { category  in
            if let id = category.id , let name = category.name, let items = category.items{
                let cateogryToBeSaved = Category(context: self.context)
                cateogryToBeSaved.id = "\(id)"
                cateogryToBeSaved.name = name
                items.forEach { item in
                    let itemToBeSaved = Item(context: self.context)
                    itemToBeSaved.id = "\(item.id ?? 0)"
                    itemToBeSaved.name = "\(item.name ?? "")"
                    itemToBeSaved.icon = "\(item.icon ?? "")"
                    itemToBeSaved.price = item.price ?? 0.0
                    cateogryToBeSaved.addToItems(itemToBeSaved)
                }
             
                do{
                    try context.save()
                    onCompletion(nil)
                }
                catch{
                    print(error)
                    onCompletion(error)
                }
            }
        }
    }
    func getAllData() -> Result<[Category],Error>{
        do{
            let categories = try context.fetch(Category.fetchRequest())
            return .success(categories)
        }
        catch{
            print(error)
            return .failure(error)
        }
        
        
    }
    
    func isCoreDataEmpty() -> Bool{
        if let categories = try? context.fetch(Category.fetchRequest()){
            return categories.isEmpty
        }
        
        return true
    }
}
