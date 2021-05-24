//
//  RegistrVC.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit

class RegistrVC: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var register: UIButton!

    deinit {
        print("Deinit RegistrVC")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // очистка введенных значений
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        username.text = ""
        lastname.text = ""
        email.text = ""
        password.text = ""
        
    }
    // регистрация пользователя в Firestore
    @IBAction func regUser(_ sender: UIButton) {
        AuthService.shared.register(username: username.text, lastname: lastname.text,
                                    email: email.text, password: password.text) { (result) in
            switch result {
            case .success(let muser):
                self.alertShow(with: "User succecful!", and: "Good Luck!")
                FirestoreService.shared.saveUser(id: muser.uid, email: self.email.text!, username: self.username.text!, lastname: self.lastname.text) { (error) in
                    
                    switch error {
                    case .success(_):
                        self.viewWillAppear(true)
                        let authVC = self.storyboard!.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                        authVC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(authVC, animated: true)

                    case .failure(_):
                        print("error")
                    }
                }
            case .failure(let error):
                self.alertShow(with: "Error add user!", and: error.localizedDescription)
            }
        }
    }
    
}
