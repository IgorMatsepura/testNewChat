//
//  AuthService.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//

import UIKit
import FirebaseAuth
import Firebase

class AuthService {
    
    private let auth = Auth.auth()
    static let shared = AuthService()
    
    // Авторизаци пользователя в Firebase
    func login(email: String?, password: String?, completion: @escaping(Result<User, Error>) -> Void){
        
        guard let email = email, let password = password  else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) {(result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    // регистрация пользователя по данным из вводимых на экране с completion логом
    func register(username: String?, lastname: String?, email: String?, password: String?,
                  completion: @escaping(Result<User, Error>) -> Void) {
        
        guard ValidatorService.isFleild(username: username, lastname: lastname, email: email, password: password)
        else {
            completion(.failure(AuthError.notFilled))
            return
        }

        auth.createUser(withEmail: email!, password: password!) {(result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}

