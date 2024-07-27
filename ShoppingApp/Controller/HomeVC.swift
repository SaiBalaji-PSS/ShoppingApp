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
    @IBOutlet weak var cartView: UIView!
    
    @IBOutlet weak var cartItemLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        self.configureUI()
        vm.loadAllProducts()
        self.setupBinding()
        vm.getAllDatafromCart()
        
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
                          
                            print(item.id ?? "")
                        }
                    }
                }
                self.tableView.reloadData()
            }
            
        }.store(in: &cancellables)
        vm.$carts.receive(on: RunLoop.main).sink { cartItems  in
            self.cartItemLbl.text = "\(cartItems.count)"
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
        self.navigationController?.navigationBar.isHidden = true
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        self.tableView.separatorStyle = .none
        self.cartView.layer.cornerRadius = 10
        self.cartView.isUserInteractionEnabled = true
        self.cartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cartBtnTapped)))
        
    }
    
    
    @objc func cartBtnTapped(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}




extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.categories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = (self.vm.categories[indexPath.row].items?.allObjects as? [Item])?.sorted(by: { item1, item2 in
            Int(item1.id ?? "0")! < Int(item2.id ?? "0")!
        }){
           if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell{
                cell.updateCell(title: self.vm.categories[indexPath.row].name ?? "", items: item)
                cell.tableViewIndex = indexPath
                cell.delegate = self
                return cell
            }
        }
       return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension HomeVC: CategoryCellDelegate{
    func didPressAddBtn(favouriteItem: Item) {
        self.vm.saveItemToCart(id: favouriteItem.id ?? "", name: favouriteItem.name ?? "",units: 1, imageURL: favouriteItem.icon ?? "", price: "\(favouriteItem.price)")
    }

    func didPressFavouriteBtn(tableViewIndex: IndexPath, index: IndexPath, likedItem: Item) {
        print("ITEM  \(likedItem.name ?? "") IS \(likedItem.isLiked)")
        self.vm.updateLikeStatus(itemLiked: likedItem, isLiked: likedItem.isLiked)
    }
}
