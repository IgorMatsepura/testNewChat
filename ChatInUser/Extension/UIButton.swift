//
//  UIButton.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 14.02.2021.
//

import UIKit

extension UIButton {
    
    convenience init (title: String, backgroundColor: UIColor,
                      titlecolor: UIColor, font: UIFont?) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titlecolor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
    }
}
