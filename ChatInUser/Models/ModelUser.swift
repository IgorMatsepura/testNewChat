//
//  ModelUser.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit
import FirebaseFirestore

class ModelUser: Hashable, Decodable {
    var username: String
    var email: String
    var lastname: String
    var id: String
    
    init(username: String, email: String, lastname: String, id: String) {
        self.username = username
        self.email = email
        self.lastname = lastname
        self.id = id
        print("class user Init \(username) and \(id)")
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil}
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let lastname = data["lastname"] as? String,
        let id = data["uid"] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.lastname = lastname
        self.id = id
        print("struct user Init \(username) and \(id)")

    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let lastname = data["lastname"] as? String,
        let id = data["uid"] as? String else { return nil }
        
        self.username = username
        self.email = email
        self.lastname = lastname
        self.id = id
        print("struct user Query \(username) and \(id)")

    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["lastname"] = lastname
        rep["uid"] = id
        return rep
    }
    
    deinit {
        print("Deinit Model User \(id) and \(username)")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ModelUser, rhs: ModelUser) -> Bool {
        return lhs.id == rhs.id
    }
}
