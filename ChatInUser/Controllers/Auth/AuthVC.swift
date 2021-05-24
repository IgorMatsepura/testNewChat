//
//  AuthVC.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit


class AuthVC: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var startChat: UIButton!
    
  //  let userVC = UserVC()

    deinit {
        print("Deinit AuthVC")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

    }

    // очистка полей
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        email?.text = ""
        password?.text = ""
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    //  Авторизация пользователя в Firestore и переход на storyboard
    @IBAction func Start(_ sender: UIButton) {
        
        AuthService.shared.login(email: email.text!,
                                 password: password.text!) { (result) in
            switch result {
            case .success(let user):
                self.alertShow(with: "Succecfull!!!", and: "You autorization! ") {
                    FirestoreService.shared.getUserData(user: user) { [self] (result) in
                        switch result {
                        case .success(let chat):
                            let userVC = self.storyboard!.instantiateViewController(withIdentifier: "UserVC") as! UserVC
                            userVC.currentUsers = chat.username
                            userVC.usersId = chat.id
                            userVC.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(userVC, animated: true)
                        case .failure(let muser):
                            self.alertShow(with: "Error!", and: muser.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                self.alertShow(with: "Error", and: error.localizedDescription)
            }
        }
    }
}

