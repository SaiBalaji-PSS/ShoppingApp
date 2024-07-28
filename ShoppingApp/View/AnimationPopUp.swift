//
//  AnimationPopUp.swift
//  ShoppingApp
//
//  Created by Sai Balaji on 28/07/24.
//

import UIKit
import Lottie


//Custom popup to display the animation
class AnimationPopUp: UIViewController {

    //MARK: - PROPERTIES
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var customAnimationView: UIView!
    private var animationView: LottieAnimationView?
    var animationName: String?
    var messageText = ""
    var speed: CGFloat?
    
    //MARK: - LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupAnimation()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AnimationPopUp", bundle: Bundle(for: CategoriesPopupVC.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupAnimation(){
        if let animationName{
            self.messageLbl.text = messageText
            animationView = .init(name: animationName)
            self.customAnimationView.addSubview(animationView!)
            animationView?.translatesAutoresizingMaskIntoConstraints = false
            
            animationView?.centerXAnchor.constraint(equalTo: self.customAnimationView.centerXAnchor).isActive = true
            animationView?.centerYAnchor.constraint(equalTo: self.customAnimationView.centerYAnchor).isActive = true
            animationView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
            animationView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
            animationView?.animationSpeed = speed ?? 1.0
            animationView?.play(completion: { completed in
                if completed{
                    //dismiss the popup after animation is completed 
                    self.dismiss(animated: true)
                }
            })
        }
       
    }

    
    func show(){
        if #available(iOS 13, *){
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true)
        }
        else{
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true)
        }
    }
    

}
