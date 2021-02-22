//
//  FirestoreService.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return db.collection("user")
    }
    
    private var chatsRef: CollectionReference {
        return db.collection(["user", currentUser.id, "chats"].joined(separator: "/"))
    }
    
    
    var currentUser: ModelUser!
    var chat: ModelChat!
    
    //информация по пользователю
    func getUserData(user: User, completion: @escaping (Result<ModelUser, Error >) -> Void) {
        let docRef = userRef.document(user.uid)
    
        docRef.getDocument { (document, error) in
            if let document = document {

                guard let muser = ModelUser(document: document) else {
                    completion(.failure(AuthError.cannotUnwrapToModelUser))
                    return
                }
                
                self.currentUser = muser
                completion(.success(muser))
                print("XXXXXX3-> \(muser)")
            }  else {
            completion(.failure(AuthError.cannotGetUserInfo))
        }
    }
}
// сохранение пользователя в FireStore
func saveUser(id: String, email: String, username: String?, lastname: String?,  completion: @escaping (Result<ModelUser, Error>) -> Void) {
    
    guard ValidatorService.isFleildReg(username: username, lastname: lastname, email: email)
    else {
        completion(.failure(AuthError.notFilled))
        return
    }

    let muser = ModelUser(username: username!,
                          email: email, lastname: lastname!,
                          id: id)
    self.userRef.document(muser.id).setData(muser.representation){ (error) in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(muser))
        }
    }
  }
    
    // создание чата и сообщений в нем
    func chating(message: String, user: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let refChat = db.collection(["user", user, "chats"].joined(separator: "/"))
        let messageRef = refChat.document(self.currentUser.id).collection("messages")
        
        let message = ModelMessages(user: currentUser, content: message)
        let chat = ModelChat(friendUsername: currentUser.username,
                             friendId: currentUser.id,
                             lastname: currentUser.lastname,
                             lastMessageContent: message.content)
        
        refChat.document(currentUser.id).setData(chat.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    // добавление пользователя к чату
    func chatAddUser(user: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let refChat = db.collection(["user", user, "chats"].joined(separator: "/"))
        
        refChat.document(currentUser.id).setData(currentUser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
            }
    }

    // messsage send
    func sendMessage(chat: ModelChat, message: ModelMessages, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = userRef.document(chat.friendId).collection("chats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("messages")
        let myMessageRef = userRef.document(currentUser.id).collection("chats").document(chat.friendId).collection("messages")
        
        let chatForFriend = ModelChat(friendUsername: currentUser.username,
                                      friendId: currentUser.id, lastname: currentUser.lastname,
                                      lastMessageContent: message.content)
        
        friendRef.setData(chatForFriend.representation) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
 
}


extension ModelUser {
    static func createSelect(from documents: [QueryDocumentSnapshot]) -> [ModelUser] {
        var user = [ModelUser]()
        for document in documents {
            user.append((ModelUser(username: document["name"] as? String ?? "",
                                   email: document["email"] as? String ?? "",
                                   lastname: document["lastName"] as? String ?? "",
                                   id: document["uid"] as? String ?? "")))
        }
        return user
    }
}

