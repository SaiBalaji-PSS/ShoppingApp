//
//  ItemCell.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import SDWebImage


protocol ItemCellDelegate: AnyObject{
    func didPressFavouriteBtn(indexPath: IndexPath)
    func didPressAddBtn(indexPath: IndexPath)
}
class ItemCell: UICollectionViewCell {
    weak var delegate: ItemCellDelegate?
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var favouriteBtnPressed: UIButton!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    func updateCell(itemName: String,price: String,imageURL: String,isLiked: Bool){
        self.itemName.text = itemName
        self.priceLbl.text = "$ \(price)"
        self.itemImageView.sd_setImage(with: URL(string: imageURL))
        if isLiked{
            favouriteBtnPressed.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else{
            favouriteBtnPressed.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.dropShadow(scale: true)
        
    }
    @IBAction func addBtnPressed(_ sender: UIButton) {
        if let indexPath{
            self.delegate?.didPressAddBtn(indexPath: indexPath)
        }
        
    }
    
    @IBAction func favouriteBtnPressed(_ sender: Any) {
        if let indexPath{
            self.delegate?.didPressFavouriteBtn(indexPath: indexPath)
        }
    }
}
