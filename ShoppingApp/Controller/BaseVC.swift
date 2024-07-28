//
//  BaseVC.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 28/07/24.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlert(title: String,message: String){
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(avc, animated: true)
    }

}
