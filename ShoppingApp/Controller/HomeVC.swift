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
        
        self.setupBinding()
        vm.getAllProducts()
    }

    
    func setupBinding(){
        vm.$categories.receive(on: RunLoop.main).sink { cateogories in
            print(cateogories.count)
        }.store(in: &cancellables)
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
            }
        }.store(in: &cancellables)
    }

}

