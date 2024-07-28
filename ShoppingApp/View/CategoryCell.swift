//
//  CategoryCell.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit


//Protocol for add button action, favorite button action, expand button action
protocol CategoryCellDelegate: AnyObject{
    func didPressAddBtn(favouriteItem: Item)
    func didPressFavouriteBtn(tableViewIndex: IndexPath,index: IndexPath,likedItem: Item)
    func expandBtnPressed(index: IndexPath)
}

class CategoryCell: UITableViewCell {
    //MARK: - PROPERTIES
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var expandView: UIView!
    
    private var items = [Item]()
    var tableViewIndex: IndexPath?
    weak var delegate: CategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  self.expandView.isHidden = true
        // Initialization code
        self.configureCell()
    }

    
    func configureCell(){
        self.itemCollectionView.delegate = self
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.register(UINib(nibName: "ItemCell", bundle: nil),forCellWithReuseIdentifier: "ItemCell")
        self.itemCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func expandBtnPressed(_ sender: UIButton) {
        if let tableViewIndex{
            self.delegate?.expandBtnPressed(index: tableViewIndex)
        }
        
    }
    
    func updateCell(title: String,items:[Item]){
        self.titleLbl.text = title
        self.items.removeAll()
        self.items = items
        self.itemCollectionView.reloadData()
    }
    
    
    
}
//MARK: - COLLECTION VIEW DELEGATE METHODS
extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(section) ITEM COUNT IS  \(self.items.count)")
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell{
            cell.indexPath = indexPath
            cell.updateCell(itemName: self.items[indexPath.row].name ?? "", price: "\(self.items[indexPath.row].price)", imageURL: self.items[indexPath.row].icon ?? "", isLiked: self.items[indexPath.row].isLiked)
          
            cell.delegate = self
            cell.dropShadow()
            
            
            return cell
        }
      
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 250)
    }
    
}

extension CategoryCell: ItemCellDelegate{
    func didPressAddBtn(indexPath: IndexPath) {
            self.delegate?.didPressAddBtn(favouriteItem: self.items[indexPath.row])
    }
    func didPressFavouriteBtn(indexPath: IndexPath) {
        if let tableViewIndex{
            self.items[indexPath.item].isLiked.toggle()
          //  print("ITEM IS \(self.items[indexPath.item].name)")
            self.itemCollectionView.reloadData()
            self.delegate?.didPressFavouriteBtn(tableViewIndex: tableViewIndex, index: indexPath,likedItem: self.items[indexPath.item])
        }
    }
}


