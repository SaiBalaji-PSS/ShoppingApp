//
//  FavoriteVC.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 27/07/24.
//

import UIKit
import Combine


class FavoriteVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var vm = FavoriteViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
        self.setupBiding()
        vm.getAllFavoriteItems()
        
    }
    
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        self.tableView.separatorStyle = .none
    }
    
    
    func setupBiding(){
        vm.$favoriteItems.receive(on: RunLoop.main).sink { favoriteItems in
            if favoriteItems.isEmpty == false{
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
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

extension FavoriteVC: FavoriteCellDelegate{
    func addBtnPressed(index: IndexPath, unit: Int, item: Favorite, price: Double) {
        self.vm.updateItemUnitCount(item: item, unit: unit,price: price)
    }
}
