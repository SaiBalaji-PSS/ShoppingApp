//
//  FavoriteCell.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit

protocol FavoriteCellDelegate: AnyObject{
    func addBtnPressed(index: IndexPath,unit: Int,item: Favorite,price: Double)
}

class FavoriteCell: UITableViewCell {
    weak var delegate: FavoriteCellDelegate?
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var unitNameLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    var index = IndexPath()
    private var currentPirce = 0.0
    private var currentUnit = 0
    private var currentItem: Favorite?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.dropShadow(scale: true)
    }
    
    func updateData(item: Favorite){
        self.currentItem = item
        self.currentPirce = item.price
        self.currentUnit = Int(item.unit)
        self.iconImageView.sd_setImage(with: URL(string: item.icon ?? ""))
        self.itemNameLbl.text = item.name
        self.unitNameLbl.text = "\(item.unit) \(item.price)"
        self.favoriteBtn.setImage(item.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        
    }
    
    
    @IBAction func addBtnPressed(_ sender: Any) {
        currentUnit = currentUnit + 1
        let updatedPrice = Double(currentUnit) * currentPirce
        self.unitNameLbl.text = "\(currentUnit) \(updatedPrice)"
        if let currentItem{
            self.delegate?.addBtnPressed(index: index, unit: currentUnit, item: currentItem, price: currentPirce)
        }
        
    }
    
}
