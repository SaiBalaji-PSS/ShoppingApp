//
//  ItemCell.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import SDWebImage

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func updateCell(itemName: String,price: String,imageURL: String){
        self.itemName.text = itemName
        self.priceLbl.text = price
        self.itemImageView.sd_setImage(with: URL(string: imageURL))
        
    }
    @IBAction func addBtnPressed(_ sender: UIButton) {
        
    }
    
}
