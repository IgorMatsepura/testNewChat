//
//  ChatVC.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore



//
//struct ModelChats: Hashable, Decodable {
//    var friendUsername: String
//    var lastname: String
//    var lastMessageContent: String
//    var friendId: String
//
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(friendId)
//    }
//
//     static func == (lhs: ModelChats, rhs: ModelChats) -> Bool {
//        return lhs.friendId == rhs.friendId
//     }
//}
//
//



class ChatVC: MessagesViewController {
    
    
    private var messages: [ModelMessages] = []
    private var messageListener: ListenerRegistration?
    
    private let user: ModelUser
    private var incom: String
    
    init(user: ModelUser, userId: String) {
        self.user = user
        self.incom = userId
        super.init(nibName: nil, bundle: nil)
        
        title = user.username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        messageListener?.remove()
        print("Deinit ChatVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        messagesCollectionView.backgroundColor = .white
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        print("XXXXXXXXX- CHAT YOY->\(user.id)")
        print("XXXXXXXXX- CHAT WITH->\(incom)")
        // так как с коллекцией передача сложилась криво пришлось вручную загонять ссылки
        // на БД и линки на чатующихся пользователей, отслеживание по снэпшоту каждой новой записи
        let ref = FirestoreService.shared.db.collection("user").document(user.id).collection("chats").document(incom).collection("messages")

        let messagesListener = ref.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else { return }
            
            snapshot.documentChanges.forEach { (diff) in
                guard let message = ModelMessages(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    self.inputMessage(message: message)
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
        messagesCollectionView.reloadData()
        print(messagesListener)
    }
    // инициализация ввода сообщения в окне его сортировка
    private func inputMessage(message: ModelMessages) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
                
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
}

//MARK: MessagesDataSource
extension ChatVC: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    // возвращаем количество пересылки сообщений
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    // отображение даты и времени сообщения для каждого 4ого
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: .none)
        } else {
            return nil
        }
    }
}
//MARK: инициализация отступов в экране чата и расстояние между сообщением и вью
extension ChatVC: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 10)
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item) % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}
//MARK: Display delegate from sender Id and you UID and type chat
extension ChatVC: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemGray6 : .darkGray
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .systemGray6
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}
//MARK: Input and add messages in Firestore
extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = ModelMessages(user: user, content: text)
    //    inputMessage(message: message)
//start worked
//        FirestoreService.shared.chating(message: message.content, user: user.id) { (result) in
//            switch result {  }
        // привести массив четез сторубоард из UserVC не получилось пришлось инициализировать тут
        let chats = ModelChat(friendUsername: user.username,
                                      friendId: user.id,
                                      lastname: user.lastname,
                                      lastMessageContent: message.content)

        FirestoreService.shared.sendMessage(chat: chats, message: message) { (result) in
            switch result {

            case .success():
                self.messagesCollectionView.scrollToLastItem()
            case .failure(let error):
                self.alertShow(with: "Error", and: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}


//MARK: preview

//import SwiftUI
//
//    struct ChatProvider: PreviewProvider {
//        static var previews: some View {
//                ContainerView().edgesIgnoringSafeArea(.all)
//
//            }
//    
//            struct ContainerView: UIViewControllerRepresentable {
//    
//                let listVC = ChatVC()
//    
//                func makeUIViewController(context: UIViewControllerRepresentableContext<ChatProvider.ContainerView>) -> ChatVC {
//                    return listVC
//                }
//                
//                func updateUIViewController(_ uiViewController: ChatProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatProvider.ContainerView>) {
//    
//                }
//            }
//    }
