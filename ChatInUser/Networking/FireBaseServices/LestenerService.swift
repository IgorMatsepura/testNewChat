//
//  LestenerService.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 14.02.2021.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()

    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("user")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    // следим за пользватеялми о добавляем их
    func usersObserve(users: [ModelUser], completion: @escaping (Result<[ModelUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
    
        let userListen = usersRef.addSnapshotListener {(querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let muser = ModelUser(document: diff.document) else { return }
                switch diff.type {
                
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.id != self.currentUserId else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return userListen
    }
    
    // следим за чатом и изменениями
    func chatsObserve(chats: [ModelChat], completion: @escaping (Result<[ModelChat], Error>) -> Void) -> ListenerRegistration? {
           var chats = chats
           let chatsRef = db.collection(["user", currentUserId, "chats"].joined(separator: "/"))
           let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
               guard let snapshot = querySnapshot else {
                   completion(.failure(error!))
                   return
               }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let chat = ModelChat(document: diff.document) else { return }
                switch diff.type {
                   case .added:
                       guard !chats.contains(chat) else { return }
                       chats.append(chat)
                   case .modified:
                       guard let index = chats.firstIndex(of: chat) else { return }
                       chats[index] = chat
                   case .removed:
                       guard let index = chats.firstIndex(of: chat) else { return }
                       chats.remove(at: index)
                   }
               }
               completion(.success(chats))
           }
           return chatsListener
       }
       
    // проверяем сообщения на новые
    func messagesObserve(chat: ModelChat, completion: @escaping (Result<ModelMessages, Error>) -> Void) -> ListenerRegistration? {
        let ref = usersRef.document(currentUserId).collection("chats").document("friendId").collection("messages")
        let messagesListener = ref.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let message = ModelMessages(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        return messagesListener
    }
}

