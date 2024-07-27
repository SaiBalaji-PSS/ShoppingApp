//
//  CategoryCell.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit



protocol CategoryCellDelegate: AnyObject{
    func didPressAddBtn(favouriteItem: Item)
    func didPressFavouriteBtn(tableViewIndex: IndexPath,index: IndexPath,likedItem: Item)
}
class CategoryCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    private var items = [Item]()
    var tableViewIndex: IndexPath?
    weak var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.register(UINib(nibName: "ItemCell", bundle: nil),forCellWithReuseIdentifier: "ItemCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func expandBtnPressed(_ sender: UIButton) {
    }
    
    func updateCell(title: String,items:[Item]){
        self.titleLbl.text = title
        self.items = items
        self.itemCollectionView.reloadData()
    }
    
    
    
}
extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell{
            cell.indexPath = indexPath
            cell.updateCell(itemName: self.items[indexPath.row].name ?? "", price: "\(self.items[indexPath.row].price)", imageURL: self.items[indexPath.row].icon ?? "", isLiked: self.items[indexPath.row].isLiked)
            print("IS CELL ITEM LIKED \(self.items[indexPath.row].isLiked)")
            cell.delegate = self
            cell.layer.cornerRadius = 4.0
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1.0
      
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
}
extension CategoryCell: ItemCellDelegate{
    func didPressAddBtn(indexPath: IndexPath) {
        if let tableViewIndex{
     
            self.delegate?.didPressAddBtn(favouriteItem: self.items[indexPath.row])
        }
    }
    func didPressFavouriteBtn(indexPath: IndexPath) {
        if let tableViewIndex{
            self.items[indexPath.item].isLiked.toggle()
            print("ITEM IS \(self.items[indexPath.item].name)")
            self.itemCollectionView.reloadData()
            self.delegate?.didPressFavouriteBtn(tableViewIndex: tableViewIndex, index: indexPath,likedItem: self.items[indexPath.item])
        }
    }
}

