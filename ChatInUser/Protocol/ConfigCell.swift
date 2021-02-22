//
//  ConfigCell.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 14.02.2021.
//

import Foundation


protocol ConfigCell {
    static var reuseId: String {get}
 //   func configure<U: Hashable>(with value: U)

    func configure(with value: ModelUser)
}
