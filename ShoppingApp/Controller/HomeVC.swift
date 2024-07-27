//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    private var vm = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
 
        vm.loadAllProducts()
        self.setupBinding()
        
    }

    
    func setupBinding(){
        vm.$categories.receive(on: RunLoop.main).sink { cateogories in
            print(cateogories.count)
            if cateogories.isEmpty == false{
              //  DatabaseService.shared.saveData(categories: cateogories)
                cateogories.forEach { category  in
                    print("Category is \(category.name ?? "")")
                    if let items = category.items?.allObjects as? [Item]{
                        print("Items are: \n")
                        items.forEach { item  in
                          
                            print(item.name ?? "")
                        }
                    }
                }
            }
            
        }.store(in: &cancellables)
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
            }
        }.store(in: &cancellables)
    }
    
    func loadData(){
        
    }
    
    

}

