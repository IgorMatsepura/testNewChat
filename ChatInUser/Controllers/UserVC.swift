//
//  UserVC.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit
import FirebaseFirestore
import Firebase


class UserVC: UIViewController {


    var users = [ModelUser]()
    var chats = [ModelChat]()

    var currentUsers: String!
    var usersId: String!
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ModelUser>?
    
    private var chatsListener: ListenerRegistration?
    private var userListener: ListenerRegistration?
    
    deinit {
        print("Deinit UserVC")
        print("Deinit Listener")
        self.userListener?.remove()
        self.chatsListener?.remove()
    }
    
    enum Section: Int, CaseIterable {
        case  chats
    }
    
    weak var delegate: UserVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        createDataSource()
        reloadData()
        title = currentUsers
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))
        
        userListener = ListenerService.shared.usersObserve(users: users, completion: { (result) in
            switch result {
            
            case .success(let users):
                self.users = users
                self.reloadData()
            case .failure(let error):
                self.alertShow(with: "Error!", and: error.localizedDescription)
            }
        })
        
        
//
//        let chatsRef = FirestoreService.shared.db.collection(["user", usersId, "chats"].joined(separator: "/"))
//        let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
//            guard let snapshot = querySnapshot else { return }
//
//            snapshot.documentChanges.forEach { (diff) in
//                guard let chat = ModelChat(document: diff.document) else { return }
//                switch diff.type {
//                case .added:
//                    guard !self.chats.contains(chat) else { return }
//                    self.chats.append(chat)
//              
//                case .modified:
//                    break
//                case .removed:
//                    break
//                }
//            }
//           }

    }

    
//MARK: Setup collection view
    private func setupView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.reuseId)
        
        collectionView.delegate = self

    }
    
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ModelUser>()
        snapshot.appendSections([.chats])
        snapshot.appendItems(users, toSection: .chats)
        dataSource?.apply(snapshot, animatingDifferences: true)
    
    }

}
// MARK: Create data source
extension UserVC {
    
    private func configure<T: ConfigCell>(cellType: T.Type, value: ModelUser, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {
            fatalError("Unable to \(cellType)")
        }
        cell.configure(with: value)
        return cell
    }

    
//MARK: Data Source
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ModelUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            
            case .chats:
                return self.configure(cellType: ChatCell.self, value: user, for: indexPath)
                //configure(collectionView: collectionView, cellType: ChatCell.self, with: user, for: indexPath)
            }
        })
    }
}

// MARK: - Setup layout
extension UserVC {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {
                fatalError("Unknown section kind")
            }
        
            switch section {
            case .chats:
                return self.createChats()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createChats() -> NSCollectionLayoutSection {
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         
         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(80))
         let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
         
         let section = NSCollectionLayoutSection(group: group)
         section.interGroupSpacing = 2
         section.contentInsets = NSDirectionalEdgeInsets.init(top: 30, leading: 10, bottom: 10, trailing: 0)
         return section
     }
}

// MARK: - UICollectionViewDelegate
extension UserVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {

        case .chats:
            print("XXXXXXXX6->\(indexPath)")
            //тут запускаем чат
            //тут добавляем в колллекцию чат и привязываем к чату ид чатующихся
            FirestoreService.shared.chatAddUser(user: chat.id) { (result) in
                switch result {

                case .success(_):
                    print("XXXXXX15->\(chat.id)")
                    print("Succecful open VC chat")
                    let chatVC = ChatVC(user: chat, userId: self.usersId)
                    chatVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(chatVC, animated: true)
                case .failure(let error):
                    print("not add to FireStore \(error.localizedDescription)")
                }
            }
        }
    }
}


// MARK: - Actions
extension UserVC {
    @objc private func signOut() {
        let ac = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard!.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                authVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(authVC, animated: false)
//                self.present(authVC, animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
             //  UIApplication.shared.keyWindow?.rootViewController = AuthVC()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }))
        DispatchQueue.main.async(execute: {
            self.present(ac, animated: true, completion: nil)
        })

    }

}
 //MARK: Preview

//import SwiftUI
//
//struct UserVCProvaider: PreviewProvider {
//    static var previews: some View {
//            ContainerView().edgesIgnoringSafeArea(.all)
//        }
//
//        struct ContainerView: UIViewControllerRepresentable {
//
//            let listVC = UserVC()
//
//            func makeUIViewController(context: UIViewControllerRepresentableContext<UserVCProvaider.ContainerView>) -> UserVC {
//                return listVC
//            }
//            func updateUIViewController(_ uiViewController: UserVCProvaider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UserVCProvaider.ContainerView>) {
//
//            }
//        }
//}

