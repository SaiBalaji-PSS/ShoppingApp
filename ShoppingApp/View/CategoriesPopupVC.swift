//
//  CategoriesPopupVC.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 28/07/24.
//

import UIKit

protocol CloseBtnDelegate: AnyObject{
    func closeBtnPressed()
}
//Custom popup for category list
class CategoriesPopupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtnImageView: UIImageView!
    weak var delegate: CloseBtnDelegate?
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "CategoriesPopupVC", bundle: Bundle(for: CategoriesPopupVC.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureUI(){
        self.closeBtnImageView.isUserInteractionEnabled = true
        self.closeBtnImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeBtnPressed)))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        self.tableView.showsVerticalScrollIndicator = false 
    }
    
    
    func show(){
        if #available(iOS 13, *){
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true)
        }
        else{
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true)
        }
    }
    
    @objc func closeBtnPressed(){
        self.delegate?.closeBtnPressed()
        self.dismiss(animated: true)
    }
    
    

}


extension CategoriesPopupVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 14.0)
        return cell
    }
}
