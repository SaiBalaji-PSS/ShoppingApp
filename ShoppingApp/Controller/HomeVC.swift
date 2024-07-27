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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        self.configureUI()
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
                self.tableView.reloadData()
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
    
    func configureUI(){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        self.tableView.separatorStyle = .none
        
        
    }
    
    

}




extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.vm.categories[indexPath.row].items?.allObjects as? [Item]{
           if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell{
                cell.updateCell(title: self.vm.categories[indexPath.row].name ?? "", items: item)
           
         
                return cell
            }
        }
       return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
