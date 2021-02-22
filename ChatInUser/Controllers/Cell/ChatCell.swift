//
//  ChatCell.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 14.02.2021.
//

import UIKit


class ChatCell: UICollectionViewCell, ConfigCell {

    static var reuseId: String = "ChatCell"
    
    let friendName = UILabel(text: "User name", font: .italicSystemFont(ofSize: 20))
    let lastname = UILabel(text: "Last name", font: .italicSystemFont(ofSize: 20))
    let lastMessage = UILabel(text: "Last Message", font: .avenir20())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        setupConstrains()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with value: ModelUser) {
         
        friendName.text = value.username
        lastname.text = value.lastname
        
        lastMessage.text = lastMessage.text
        
    }
    
    private func setupConstrains() {
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastname.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemGroupedBackground
        addSubview(friendName)
    //    addSubview(lastname)
        addSubview(lastMessage)
           
        NSLayoutConstraint.activate([
            friendName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            friendName.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 20)
                                        
        ])
//        NSLayoutConstraint.activate([
//            lastname.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//            lastname.leadingAnchor.constraint(equalTo: friendName.leadingAnchor, constant:100)
//        ])
        
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            lastMessage.leadingAnchor.constraint(equalTo: friendName.leadingAnchor, constant: 0),
        ])
        
    }
}


