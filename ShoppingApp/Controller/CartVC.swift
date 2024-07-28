//
//  CartVC.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import Combine

class CartVC: UIViewController {

    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var vm = CartViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var discountAmount = 40.0
    @IBOutlet weak var billView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.setupBinding()
        vm.getAllCartItems()
    }
    
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CartItemCell", bundle: nil   ),forCellReuseIdentifier: "CartItemCell")
        tableView.separatorStyle = .none
        billView.layer.cornerRadius = 4.0
        self.checkoutBtn.layer.cornerRadius = 4.0
        self.discountLbl.text = "-$ \(discountAmount)"
    }
    
    
    func setupBinding(){
        vm.$cartItems.receive(on: RunLoop.main).sink { cartItems in
            if cartItems.isEmpty == false{
                var price = 0.0
                cartItems.forEach { item in
                    price = price + (item.price * Double(item.quantity))
                    
                }
               
                self.subTotalLbl.text = "\(String(format:"$%.2f",price))"
                self.totalLbl.text = "\(String(format:"$%.2f",price - self.discountAmount))"
                self.billView.isHidden = false
                self.checkoutBtn.isHidden = false
            }
            else{
                self.subTotalLbl.text = "$0.00"
                self.totalLbl.text = "$0.00"
              //  self.discountLbl.text = "$0.00"
                self.billView.isHidden = true
                self.checkoutBtn.isHidden = true
            }
            self.tableView.reloadData()
        }.store(in: &cancellables)
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
            }
        }.store(in: &cancellables)
    }
    
    

    @IBAction func checkoutBtnPressed(_ sender: Any) {
        let animationVC = AnimationPopUp()
        animationVC.speed = 2
        animationVC.animationName = "checkout"
        animationVC.messageText = "Checkout Success"
        animationVC.show()
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.cartItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell{
            cell.updateCell(imageURL: vm.cartItems[indexPath.row].icon ?? "", title: vm.cartItems[indexPath.row].name ?? "" , quantity: vm.cartItems[indexPath.row].quantity , totalPrice: vm.cartItems[indexPath.row].price)
            cell.delegate = self
            cell.index = indexPath
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}

extension CartVC: CartItemCellDelegate{
    func plusBtnPressed(quantity: Int, index: IndexPath, totalPrice: String) {
        self.vm.updateCartItemQuantity(item: self.vm.cartItems[index.row], quantity: Int64(quantity))
        
        print("ITEM QUANTITY IS \(quantity) AND PRICE IS \(totalPrice)")
        self.vm.getAllCartItems()
       
       
    }
    
    func minusBtnPressed(quantity: Int, index: IndexPath, totalPrice: String) {
        if quantity <= 0{
            self.vm.removeItemFromCart(item: self.vm.cartItems[index.row])
            self.vm.getAllCartItems()
        }
        else{
            self.vm.updateCartItemQuantity(item: self.vm.cartItems[index.row], quantity: Int64(quantity))
            
            print("ITEM QUANTITY IS \(quantity) AND PRICE IS \(totalPrice)")
            self.vm.getAllCartItems()
        }
        
      
    }
}
