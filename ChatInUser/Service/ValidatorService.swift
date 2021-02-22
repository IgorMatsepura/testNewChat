//
//  ValidatorService.swift
//  ChatInUser
//
//  Created by Igor Matsepura on 12.02.2021.
//
// Различные проверки на ввод значений

import Foundation

class ValidatorService {
    
    static func isFleild(username: String?, lastname: String?, email: String?, password: String?) -> Bool {
        guard let username = username,
              let lastname = lastname,
              let email = email,
              let password = password,
              username != "",
              lastname != "",
              email != "",
              password != "" else {
                return false
        }
        return true
    }
    
    static func isFleildReg(username: String?, lastname: String?, email: String?) -> Bool {
        guard let username = username,
              let lastname = lastname,
              let email = email,
              username != "",
              lastname != "",
              email != ""
              else {return false}
        return true
    }
    

    static func isSimpleEmail (_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES $@", regEx)
        return predicate.evaluate(with: text)
    }
}
