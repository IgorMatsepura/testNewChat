//
//  ModelMessages.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 14.02.2021.
//

import UIKit
import FirebaseFirestore
import MessageKit

class ModelMessages: Hashable, MessageType {
    var sender: SenderType

    let content: String
//    let senderId : String
//    let senderUsername: String
    var sentDate: Date
    let id: String?
    
    // return id or Default value id
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: ModelUser, content: String) {
//        self.senderId = user.id
//        self.senderUsername = user.username
        sender = Sender(senderId: user.id, displayName: user.username)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else { return nil }
        guard let senderId = data["senderID"] as? String else { return nil }
        guard let senderName = data["senderName"] as? String else { return nil }
        guard let content = data["content"] as? String else { return nil }

        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderName)
        self.content = content
    }

    var representation: [String: Any] {
        let rep: [String: Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName,
            "content": content
        ]
        return rep
    }
    
    deinit {
        print("Deinit ModelMessages \(sender)")
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: ModelMessages, rhs: ModelMessages) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension ModelMessages: Comparable {
    static func < (lhs: ModelMessages, rhs: ModelMessages) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
