//
//  CartItemCell.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit

//Protocol for plus btn action and minus btn action
protocol CartItemCellDelegate: AnyObject{
    func plusBtnPressed(quantity: Int,index: IndexPath,totalPrice: String)
    func minusBtnPressed(quantity: Int,index: IndexPath,totalPrice: String)
    
}
class CartItemCell: UITableViewCell {

    
   //MARK: - PROPERTIES
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    private var totalPrice = 0.0
    var index: IndexPath = IndexPath()
    weak var delegate: CartItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.dropShadow()
        
    }
    private func setupShadow() {
         
        self.bgView.layer.borderColor = UIColor.gray.cgColor
        self.bgView.layer.borderWidth = 1
        self.bgView.layer.cornerRadius = 4.0
     
      }

    func updateCell(imageURL: String,title: String,quantity: Int64,totalPrice: Double){
        self.totalPrice = totalPrice
        self.titleLbl.text = title
        self.iconImageView.sd_setImage(with: URL(string: imageURL))
        self.quantityLbl.text = "\(quantity)"
        self.totalPriceLbl.text = "\(String(format:"$%.2f",totalPrice * Double(quantity)))"
        
        
         
    }
    
    @IBAction func plusBtnPressed(_ sender: Any) {
        if var quantity = Int(self.quantityLbl.text ?? "0"){
            quantity = quantity + 1
            self.quantityLbl.text = "\(quantity)"
           
            self.totalPriceLbl.text = "\(self.totalPrice * Double(quantity))"
            delegate?.plusBtnPressed(quantity: quantity, index: index,totalPrice: self.totalPriceLbl.text ?? "0.00")
        }
    }
    
    @IBAction func minusBtnPressed(_ sender: Any) {
        if var quantity = Int(self.quantityLbl.text ?? "0"){
            quantity = quantity - 1
            if quantity <= 0 {
                self.quantityLbl.text = "0"
                quantity = 0
            }
            else{
                self.quantityLbl.text = "\(quantity)"
                
            }
            self.totalPriceLbl.text = "\(self.totalPrice * Double(quantity))"
            delegate?.minusBtnPressed(quantity: quantity,index: index,totalPrice: self.totalPriceLbl.text ?? "0.00")
            
        }
    }
}



extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = 4.0
    }
}
