//
//  FavoriteVC.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import Combine


class FavoriteVC: UIViewController {
    //MARK: - PROPERTIES
    @IBOutlet weak var tableView: UITableView!
    var vm = FavoriteViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        self.setupBiding()
        vm.getAllFavoriteItems()
        
    }
    
    //MARK: - HELPERS
    //Setup tableview
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        self.tableView.separatorStyle = .none
    }
    
    //Setup binding between view and view model
    func setupBiding(){
        //Get all the items from favorite list
        vm.$favoriteItems.receive(on: RunLoop.main).sink { favoriteItems in
           
                self.tableView.reloadData()
            
        }.store(in: &cancellables)
        //Display error
        vm.$error.receive(on: RunLoop.main).sink { error  in
            if let error{
                print(error)
            }
        }.store(in: &cancellables)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - TABLEVIEW DELEGATE METHODS
extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.favoriteItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell{
            cell.index = indexPath
            cell.delegate = self
            cell.updateData(item: vm.favoriteItems[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
       return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//Update the item unit count in favorite entity
extension FavoriteVC: FavoriteCellDelegate{
    func addBtnPressed(index: IndexPath, unit: Int, item: Favorite, price: Double) {
        self.vm.updateItemUnitCount(item: item, unit: unit,price: price)
    }
}
