//
//  ModelChat.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit
import FirebaseFirestore

struct ModelChat: Hashable, Decodable {
    var friendUsername: String
    var lastname: String
    var lastMessageContent: String
    var friendId: String
    
    var representation: [String : Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendId"] = friendId
        rep["lastname"] = lastname
        rep["lastMessage"] = lastMessageContent
        return rep
    }
    
    init(friendUsername: String, friendId: String, lastname: String, lastMessageContent: String) {
        self.friendUsername = friendUsername
        self.lastname = lastname
        self.friendId = friendId
        self.lastMessageContent = lastMessageContent
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let friendUsername = data["friendUsername"] as? String,
              let lastname = data["lastname"] as? String,
              let friendId = data["friendId"] as? String,
              let lastMessageContent = data["lastMessage"] as? String else { return nil }
        self.friendUsername = friendUsername
        self.friendId = friendId
        self.lastname = lastname
        self.lastMessageContent = lastMessageContent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    
    
    static func == (lhs: ModelChat, rhs: ModelChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
