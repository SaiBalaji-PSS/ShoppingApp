//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import Combine

class HomeVC: BaseVC {
    //MARK: - PROPERTIES
    
    private var vm = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var expandedCells: Set<Int> = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var cartItemLbl: UILabel!
    @IBOutlet weak var customNavBar: UIView!
    @IBOutlet weak var categoryBtn: UIButton!
    
    //MARK: - LIFECYCLE METHODS
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
        expandedCells.removeAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupNavBarGradient()
    }
    
    
    //MARK: - HELPERS
    
    //Setup binding between view and view model
    func setupBinding(){
        
        vm.$categories.receive(on: RunLoop.main).sink { cateogories in
            print(cateogories.count)
            self.tableView.reloadData()
        }.store(in: &cancellables)
        
        //get all the cart items and calculate the total units in the cart
        vm.$carts.receive(on: RunLoop.main).sink { cartItems  in
            var totalCount = 0
            cartItems.forEach { cartItem in
                totalCount = totalCount + Int(cartItem.quantity)
            }
            self.cartItemLbl.text = "\(totalCount)"
        }.store(in: &cancellables)
        
        //show error
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    
    func setupNavBarGradient(){
        self.customNavBar.applyVerticalGradient(startcolor: UIColor(_colorLiteralRed: 238.0/255.0, green: 165.0/255.0, blue: 82.0/255.0, alpha: 1.0), endcolor: UIColor(_colorLiteralRed: 242.0/255.0, green: 208.0/255.0, blue: 84.0/255.0, alpha: 1.0))
        self.customNavBar.layer.cornerRadius = 15.0
        self.customNavBar.layer.masksToBounds = true
    }
    //Configure tableview  and gesture recognizers
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
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
    
    //Navigation to cart and favorite item view controllers
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
    
    //Display category popup
    @IBAction func categoryBtnPressed(_ sender: Any) {
        var categoryPopUp = CategoriesPopupVC()
        categoryPopUp.delegate = self 
        categoryPopUp.show()
        categoryPopUp.data = self.vm.categories.map({ category in
            return category.name ?? ""
        })
        self.categoryBtn.isHidden = true
    }
    
    //Show animation popup for given animation and message
    func showAnimationPopUp(name: String,message: String,speed: CGFloat){
        let animationPopUp = AnimationPopUp()
        animationPopUp.animationName = name
        animationPopUp.messageText = message
        animationPopUp.speed = speed
        animationPopUp.show()
    }
}



//MARK: - TABLE VIEW DELEGATE METHODS
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
    //Expand and collapse the table view cell
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
        //Add the item to cart in coredata and show the animation
        self.vm.saveItemToCart(id: favouriteItem.id ?? "", name: favouriteItem.name ?? "",units: 1, imageURL: favouriteItem.icon ?? "", price: "\(favouriteItem.price)")
        
        self.showAnimationPopUp(name: "cart", message: "Item added to shopping cart",speed: 2.0)
    }
    
    func didPressFavouriteBtn(tableViewIndex: IndexPath, index: IndexPath, likedItem: Item) {
        print("ITEM  \(likedItem.name ?? "") IS \(likedItem.isLiked)")
        //Update the isLiked attribute of the item in core data and add it to the favorite enitiy
        self.vm.updateLikeStatus(itemLiked: likedItem, isLiked: likedItem.isLiked)
        self.vm.addItemToFavorite(itemLiked: likedItem, isLiked: likedItem.isLiked)
        if likedItem.isLiked{
            //show like animation
            self.showAnimationPopUp(name: "like", message: "Item added to favorite list",speed: 1.0)
        }
    }
    func expandBtnPressed(index: IndexPath) {
        //Expand and collapse the table view cell
        if expandedCells.contains(index.row) {
            expandedCells.remove(index.row)
        } else {
            expandedCells.insert(index.row)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}



//Show the category button when the cateogry popup is closed
extension HomeVC: CloseBtnDelegate{
    func closeBtnPressed() {
        self.categoryBtn.isHidden = false
    }
}


extension UIView
{
   public func applyVerticalGradient(startcolor color1: UIColor,endcolor color2: UIColor)
    {
        
        let glayer = CAGradientLayer()
        glayer.colors = [color1.cgColor,color2.cgColor]
        
        glayer.frame = bounds
        layer.sublayers?.forEach({ layer in
            (layer as? CAGradientLayer)?.removeFromSuperlayer()
        })
        layer.insertSublayer(glayer, at: 0)
        
    }
    
    
    public func applyHorizontalGradient(startcolor color1: UIColor,endcolor color2: UIColor)
    {
        let glayer = CAGradientLayer()
        glayer.colors = [color1.cgColor,color2.cgColor]
        glayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        glayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        glayer.frame = bounds
        
        layer.insertSublayer(glayer, at: 0)
    }
}
