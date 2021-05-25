//
//  UIAlert.swift
//  Messenger_test
//
//  Created by Igor Matsepura on 07.02.2021.
//

import UIKit

extension UIViewController {
    
    func alertShow(with title: String, and message: String, completion: @escaping () -> Void = { } ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
