//
//  ViewController.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit

class ViewController: UIViewController {
        
    private let currentUser: ModelUser
    private let modelUserss = [ModelUser]()
    
    init(currentUser: ModelUser = ModelUser( username: "frfer",
                                             email: "fr",
                                             lastname: "fer",
                                             id: "fregtr")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
//            
//            let userVC = UserVC()
//            
//    
//            let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
//            let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
//            let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
//            
      //      viewControllers = [generatController(rootViewController: UserVC, title: "ChatInUser") ]
        }
        
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
//    private func generatController(rootViewController: UIViewController, title: String) -> UIViewController {
//        let viewVC = UIViewController(rootViewController: rootViewController)
//        viewVC.tabBarItem.title = title
//        return viewVC
//        }
    }

