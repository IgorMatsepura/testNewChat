//
//  Label.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 14.02.2021.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font
    }
}
