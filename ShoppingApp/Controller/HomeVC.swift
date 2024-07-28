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
    
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var cartItemLbl: UILabel!
    
    private var expandedCells: Set<Int> = []
    private var selectedIndex = -1
    private var isCollapse = false
    
    @IBOutlet weak var customNavBar: UIView!
    
    @IBOutlet weak var categoryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.configureUI()
        
        self.setupBinding()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.getAllDatafromCart()
        vm.loadAllProducts()
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
            var totalCount = 0
            cartItems.forEach { cartItem in
                totalCount = totalCount + Int(cartItem.quantity)
            }
            self.cartItemLbl.text = "\(totalCount)"
        }.store(in: &cancellables)
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
            }
        }.store(in: &cancellables)
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
        self.favoriteView.isUserInteractionEnabled = true
        self.favoriteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteBtnPressed)))
        self.categoryBtn.layer.cornerRadius = 4.0
        
        
      

                
   
        
    }
    
    
    @objc func cartBtnTapped(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func favoriteBtnPressed(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoriteVC") as? FavoriteVC{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func categoryBtnPressed(_ sender: Any) {
        var categoryPopUp = CategoriesPopupVC()
        categoryPopUp.delegate = self 
        categoryPopUp.show()
        categoryPopUp.data = self.vm.categories.map({ category in
            return category.name ?? ""
        })
        self.categoryBtn.isHidden = true
    }
    
    func showAnimationPopUp(name: String,message: String,speed: CGFloat){
        let animationPopUp = AnimationPopUp()
        animationPopUp.animationName = name
        animationPopUp.messageText = message
        animationPopUp.speed = speed
        animationPopUp.show()
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
        
        if expandedCells.contains(indexPath.row) {
            return 60
        } else {
            return 340
        }
        
        
    }
    
    
}

extension HomeVC: CategoryCellDelegate{
    func didPressAddBtn(favouriteItem: Item) {
        self.vm.saveItemToCart(id: favouriteItem.id ?? "", name: favouriteItem.name ?? "",units: 1, imageURL: favouriteItem.icon ?? "", price: "\(favouriteItem.price)")
        
        self.showAnimationPopUp(name: "cart", message: "Item added to shopping cart",speed: 2.0)
    }
    
    func didPressFavouriteBtn(tableViewIndex: IndexPath, index: IndexPath, likedItem: Item) {
        print("ITEM  \(likedItem.name ?? "") IS \(likedItem.isLiked)")
        self.vm.updateLikeStatus(itemLiked: likedItem, isLiked: likedItem.isLiked)
        self.vm.addItemToFavorite(itemLiked: likedItem, isLiked: likedItem.isLiked)
        if likedItem.isLiked{
            self.showAnimationPopUp(name: "like", message: "Item added to favorite list",speed: 1.0)
        }
    }
    func expandBtnPressed(index: IndexPath) {
        if expandedCells.contains(index.row) {
            expandedCells.remove(index.row)
        } else {
            expandedCells.insert(index.row)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension HomeVC: CloseBtnDelegate{
    func closeBtnPressed() {
        self.categoryBtn.isHidden = false
    }
}
